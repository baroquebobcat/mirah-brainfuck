
directory 'build'

task :compile => 'build' do
  sh "mirahc -d build bf.mirah"
end

task :test => :compile do
  sh "mirahc -c build -d build bf_test.mirah"
  sh "java -cp build BfTest"
end