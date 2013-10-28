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

puts "running tests"

# hello world no spaces
result = capture_stdout do
  BF.eval "++++++++++[>+++++++>++++++++++>+++>+<<<<-]>++.>+.+++++++..+++.>++.<<+++++++++++++++.>.+++.------.--------.>+.>."
end

expected = "Hello World!\n"
if result.equals(expected)
  print '.'
else
  puts "Fail: expected #{result} to equal '#{expected}'"
end