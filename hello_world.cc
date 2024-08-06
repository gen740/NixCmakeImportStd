export module hello_world;

import std;

export auto hello() {
  std::println("Hello, {}! from module!", "world");
}

export auto add(auto a, auto b) {
  return a + b;
}
