import std;
import hello_world;

auto main() -> int {
  std::println("Hello, World!");
  hello();
  std::println("1 + 2 = {}", add(1, 2));
  return 0;
}
