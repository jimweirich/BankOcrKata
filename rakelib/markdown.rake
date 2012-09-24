begin
  require 'bluecloth'
rescue LoadError => ex
  # blue cloth is optional for most things
end

if ! defined?(BlueCloth)

  desc "Format the README"
  task :readme do
    puts "BlueCloth must be installed to format the readme file"
  end

else

  directory "html"

  desc "Format the README"
  task :readme => "html/README.html"

  file "html/README.html" => ["html", "README.md"] do
    open("README.md") do |source|
      open('html/README.html', 'w') do |out|
        out.write(BlueCloth.new(source.read).to_html)
      end
    end
  end

end
