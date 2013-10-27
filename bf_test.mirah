import java.io.ByteArrayOutputStream
import java.io.PrintStream

puts "running tests"

# hello world no spaces
out = ByteArrayOutputStream.new


oldOut = System.out
System.setOut PrintStream.new out
BF.eval "++++++++++[>+++++++>++++++++++>+++>+<<<<-]>++.>+.+++++++..+++.>++.<<+++++++++++++++.>.+++.------.--------.>+.>."
System.setOut oldOut
result = String.new(out.toByteArray)
if result.equals("hello world\n")
  print '.'
else
  puts "Fail: expected #{result} to equal 'hello world\n'"
end