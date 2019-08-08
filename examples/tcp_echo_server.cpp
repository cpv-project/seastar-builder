#include <chrono>
#include <seastar/core/app-template.hh>
#include <seastar/core/reactor.hh>
#include <seastar/core/sleep.hh>

namespace {
	static const std::size_t port = 8000;
	
	seastar::future<> handle_connection(
		seastar::connected_socket s, seastar::socket_address a) {
		auto out = s.output();
		auto in = s.input();
		return do_with(std::move(s), std::move(a), std::move(out), std::move(in),
			[] (auto& s, auto& a, auto& out, auto& in) {
				return seastar::repeat([&out, &in] {
					return in.read().then([&out] (auto buf) {
						if (buf) {
							std::cout << "reply size: " << buf.size() << std::endl;
							return out.write(std::move(buf)).then([&out] {
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
					std::cout << "close connection from: " << a << std::endl;
					return out.close();
				});
			});
	}
	
	seastar::future<> service_loop() {
		seastar::listen_options lo;
		lo.reuse_address = true;
		return seastar::do_with(
			seastar::listen(seastar::make_ipv4_address({port}), lo),
			[] (auto& listener) {
				return seastar::keep_doing([&listener] () {
					return listener.accept().then([] (seastar::accept_result ar) {
						std::cout << "accepted connection from: " << ar.remote_address << std::endl;
						(void)handle_connection(std::move(ar.connection), std::move(ar.remote_address));
					});
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
