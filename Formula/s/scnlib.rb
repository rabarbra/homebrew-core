class Scnlib < Formula
  desc "Scanf for modern C++"
  homepage "https://scnlib.dev"
  url "https://github.com/eliaskosunen/scnlib/archive/refs/tags/v2.0.3.tar.gz"
  sha256 "507ed0e988f1d9460a9c921fc21f5a5244185a4015942f235522fbe5c21e6a51"
  license "Apache-2.0"
  head "https://github.com/eliaskosunen/scnlib.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "93c95965d29ecff98696ef99bf03ecdd53ff2a73234dd4fadf51c8763d24653d"
    sha256 cellar: :any, arm64_ventura:  "c8f4688c96805acce0e245cddf5428093b9af366aa36e2d96272f520a49c93b8"
    sha256 cellar: :any, arm64_monterey: "338509c3f274d1661d89a8d052394ff214d181d021ce13441c59e6e004b9e814"
    sha256 cellar: :any, sonoma:         "b03a81a3cd662b57324c5821632424b23c897279e4e4995cb72c50bfbe572baf"
    sha256 cellar: :any, ventura:        "e50c784cbaf52a9f82e91aa37e44753fb24680bc0db7f22fb42c75eada075c9c"
    sha256 cellar: :any, monterey:       "b843941c04a48fcf656b07fd6a2ec112dbb51283ae62fcd9c22b5b01ba7b6297"
  end

  depends_on "cmake" => :build
  depends_on "simdutf"

  def install
    args = %w[
      -DBUILD_SHARED_LIBS=ON
      -DSCN_TESTS=OFF
      -DSCN_DOCS=OFF
      -DSCN_EXAMPLES=OFF
      -DSCN_BENCHMARKS=OFF
      -DSCN_BENCHMARKS_BUILDTIME=OFF
      -DSCN_BENCHMARKS_BINARYSIZE=OFF
      -DSCN_USE_EXTERNAL_SIMDUTF=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <scn/scan.h>
      #include <cstdlib>
      #include <string>

      int main()
      {
        constexpr int expected = 123456;
        auto [result] = scn::scan<int>(std::to_string(expected), "{}")->values();
        return result == expected ? EXIT_SUCCESS : EXIT_FAILURE;
      }
    EOS

    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test", "-I#{include}", "-L#{lib}", "-lscn"
    system "./test"
  end
end
