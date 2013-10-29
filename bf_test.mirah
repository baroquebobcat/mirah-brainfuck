import java.io.ByteArrayOutputStream
import java.io.PrintStream

def capture_stdout(block: Runnable): String
  out = ByteArrayOutputStream.new
  oldOut = System.out
  System.setOut PrintStream.new out

  block.run

  System.setOut oldOut
  String.new(out.toByteArray)
end

def assert_equals expected: String, actual: String
  if actual.equals(expected)
    print '.'
  else
    puts "Fail: expected #{actual} to equal '#{expected}'"
  end
end

puts "running tests"

# hello world no spaces
result = capture_stdout do
  BF.eval "++++++++++[>+++++++>++++++++++>+++>+<<<<-]>++.>+.+++++++..+++.>++.<<+++++++++++++++.>.+++.------.--------.>+.>."
end
assert_equals "Hello World!\n", result

puts "done."