import java.io.ByteArrayOutputStream
import java.io.ByteArrayInputStream
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
    puts "Fail: expected '#{actual}' to equal '#{expected}'"
  end
end

puts "running tests"

# hello world no spaces
result = capture_stdout do
  BF.eval "++++++++++[>+++++++>++++++++++>+++>+<<<<-]>++.>+.+++++++..+++.>++.<<+++++++++++++++.>.+++.------.--------.>+.>."
end
assert_equals "Hello World!\n", result

result = capture_stdout do
  oldIn = System.in
  System.setIn ByteArrayInputStream.new "brainfuckyeah".getBytes
  BF.eval "
-,+[                         Read first character and start outer character reading loop
    -[                       Skip forward if character is 0
        >>++++[>++++++++<-]  Set up divisor (32) for division loop
                               (MEMORY LAYOUT: dividend copy remainder divisor quotient zero zero)
        <+<-[                Set up dividend (x minus 1) and enter division loop
            >+>+>-[>>>]      Increase copy and remainder / reduce divisor / Normal case: skip forward
            <[[>+<-]>>+>]    Special case: move remainder back to divisor and increase quotient
            <<<<<-           Decrement dividend
        ]                    End division loop
    ]>>>[-]+                 End skip loop; zero former divisor and reuse space for a flag
    >--[-[<->+++[-]]]<[         Zero that flag unless quotient was 2 or 3; zero quotient; check flag
        ++++++++++++<[       If flag then set up divisor (13) for second division loop
                               (MEMORY LAYOUT: zero copy dividend divisor remainder quotient zero zero)
            >-[>+>>]         Reduce divisor; Normal case: increase remainder
            >[+[<+>-]>+>>]   Special case: increase remainder / move it back to divisor / increase quotient
            <<<<<-           Decrease dividend
        ]                    End division loop
        >>[<+>-]             Add remainder back to divisor to get a useful 13
        >[                   Skip forward if quotient was 0
            -[               Decrement quotient and skip forward if quotient was 1
                -<<[-]>>     Zero quotient and divisor if quotient was 2
            ]<<[<<->>-]>>    Zero divisor and subtract 13 from copy if quotient was 1
        ]<<[<<+>>-]          Zero divisor and add 13 to copy if quotient was 0
    ]                        End outer skip loop (jump to here if ((character minus 1)/32) was not 2 or 3)
    <[-]                     Clear remainder from first division if second division was skipped
    <.[-]                    Output ROT13ed character from copy and clear it
    <-,+                     Read next character
]  "
  System.setIn oldIn
end

assert_equals "oenvashpxlrnu", result



# swap
result = capture_stdout do
  BF.eval "++[>++++[>++++<-]<-]>>+     puts a '!' in position 2
           <<                          back to position 0 
           ++++++[>>>++++++<<<-]>>>
                                    should be 0|0|!|$|etc with ptr at 3
           <
           .>.                      print !$
           <                        at ptr 2
           [->>+<<]>[-<+>]>[-<+>]   three cell swap
           <<
           .>.
  "
end
assert_equals "!$$!", result

puts "done."
