import java.io.InputStream
import java.io.StringBufferInputStream
import java.io.InputStreamReader

class BF
  def self.eval(str: String): void
    bf = BF.new StringBufferInputStream.new(str)
    bf.execute
  end
  def initialize source: InputStream
    @reader = InputStreamReader.new source
    @index = 0
    @array = char[30_000]
  end

  def execute : void
    while (c = @reader.read) > 0
      cmd = char(c)
      if cmd == ?>
        @index += 1
      elsif cmd == ?<
        @index -= 1
      else
        puts cmd
      end
    end
    puts @index
  end
end