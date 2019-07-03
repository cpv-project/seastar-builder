#include <chrono>
#include <seastar/core/app-template.hh>
#include <seastar/core/reactor.hh>
#include <seastar/core/future.hh>
#include <seastar/core/future-util.hh>
#include <seastar/core/sleep.hh>
#include <seastar/core/thread.hh>
#include <seastar/core/reactor.hh>
#include <seastar/net/inet_address.hh>

namespace {
	const std::string ip("127.0.0.1");
	const std::size_t port = 8000;
	
	seastar::future<> runClient() {
		seastar::socket_address addr(seastar::ipv4_addr(seastar::net::inet_address(ip), port));
		return seastar::engine().net().connect(addr).then([] (auto c) {
			auto in = c.input();
			auto out = c.output().detach();
			return seastar::do_with(
				std::move(c), std::move(in), std::move(out),
				[] (auto& c, auto& in, auto& out) {
				return out.put(seastar::net::packet::from_static_data("GET /", 5)).then([&out] {
					return seastar::repeat([&out] {
						std::cout << "start writing" << std::endl;
						return out.put(seastar::net::packet::from_static_data("_", 1)).then([&out] {
							std::cout << "write success" << std::endl;
							return seastar::sleep(std::chrono::seconds(1));
						}).then([] {
							return seastar::stop_iteration::no;
						});
					});
				}).then([&in] {
					return in.close();
				}).then([&out] {
					return out.close();
				});
			});
		});
	}
}

int main(int argc, char** argv) {
	seastar::app_template app;
	app.run_deprecated(argc, argv, [] { return runClient(); });
	return 0;
}

