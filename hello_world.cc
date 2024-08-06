export module hello;

import std;

export auto hello() {
  std::println("Hello, {}!", "world");
}

export auto add(auto a, auto b) {
  return a + b;
}
