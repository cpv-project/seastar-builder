#include <chrono>
#include <string_view>
#include <seastar/core/app-template.hh>
#include <seastar/core/reactor.hh>
#include <seastar/core/sleep.hh>

namespace {
	static const std::size_t port = 8000;
	static std::string_view response(
R"(HTTP/1.1 200 OK
Server: nginx
Date: Thu, 08 Nov 2018 09:10:41 GMT
Content-Type: text/html
Content-Length: 60
Connection: keep-alive

hell0
hell1
hell2
hell3
hell4
hell5
hell6
hell7
hell8
hell9
)");

	seastar::future<> handle_connection(
		seastar::connected_socket s, seastar::socket_address a) {
		auto out = s.output().detach();
		auto in = s.input();
		return do_with(std::move(s), std::move(a), std::move(out), std::move(in),
			[] (auto& s, auto& a, auto& out, auto& in) {
				return seastar::repeat([&out, &in] {
					return in.read().then([&out] (auto buf) {
						if (buf) {
							// seastar::net::packet p = seastar::net::packet::from_static_data(
							//	response.data(), response.size());
							seastar::temporary_buffer<char> p(
								const_cast<char*>(response.data()),
								response.size(), seastar::deleter());
							return out.put(std::move(p)).then([&out] {
								return out.flush();
							}).then([] {
								return seastar::stop_iteration::no;
							});
						} else {
							return seastar::make_ready_future<seastar::stop_iteration>(
								seastar::stop_iteration::yes);
						}
					});
				}).then([&out, &a] {
					// std::cout << "close connection from: " << a << std::endl;
					return out.close();
				});
			});
	}
	
	void on_accepted(seastar::accept_result ar) {
		thread_local static int count = 0;
		++count;
		if (count % 100 == 0) {
			std::cout << "accepted " << count << " connections" << std::endl;
		}
		// std::cout << "accepted connection from: " << a << std::endl;
		seastar::schedule(seastar::make_task([ar=std::move(ar)] () mutable {
			(void)handle_connection(std::move(ar.connection), std::move(ar.remote_address));
		}));
	}
	
	seastar::future<> service_loop() {
		seastar::listen_options lo;
		lo.reuse_address = true;
		lo.listen_backlog = 65535;
		thread_local static auto last_started_accept = std::chrono::steady_clock::now();
		return seastar::do_with(
			seastar::listen(seastar::make_ipv4_address({port}), lo),
			[] (auto& listener) {
				return seastar::keep_doing([&listener] () {
					auto now = std::chrono::steady_clock::now();
					auto delta = (now - last_started_accept) / std::chrono::milliseconds(1);
					last_started_accept = now;
					if (delta > 1000) {
						std::cout << "started accept loop since " << delta << "ms after last time" << std::endl;
					}
					thread_local std::size_t count_once_max = 0;
					std::size_t count_once = 0;
					while (true) {
						auto f = listener.accept();
						if (f.available()) {
							++count_once;
							(void)f.then(&on_accepted);
						} else {
							if (count_once > count_once_max) {
								count_once_max = count_once;
							}
							if (count_once > 10) {
								std::cout << "accepted " << count_once << " connections at once (max: " <<
						       			count_once_max << ")" << std::endl;
							}
							return f.then(&on_accepted);
						}
					}
				});
			});
	}
}

int main(int argc, char** argv) {
	seastar::app_template app;

	app.run_deprecated(argc, argv, [] {
		return seastar::parallel_for_each(boost::irange<unsigned>(0, seastar::smp::count),
			[] (unsigned c) {
				return seastar::smp::submit_to(c, service_loop);
		});
	});

	return 0;
}
