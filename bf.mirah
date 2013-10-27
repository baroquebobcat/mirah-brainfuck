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
  end

  def execute : void
    while (c = @reader.read) > 0
      puts c
    end
  end
end