class ExceptionViewer
  attr_reader :app, :exception, :res

  def initialize(app)
    @app = app
    @res = Rack::Response.new
    @exception = nil
  end

  def call(env)
    begin
      app.call(env)
    rescue => e
      @exception = e
      exception_page
    end
  end

  private
  def exception_page
    res.status = 500
    res["Content-Type"] = "text/html"
    res.write(content)
    res.finish
  end

  def content
    dir_path = File.dirname(__FILE__)
    path = "#{dir_path}/../../views/exception_view.html.erb"
    template = File.read(path)

    ERB.new(template).result(binding)
  end

  def backtrace
    exception.backtrace
  end

  def source
    backtrace.first
  end

  def message
    exception.message
  end

  def code_preview
    match_data = source.match(/^(.+):(\d+)(:in.+)?$/)
    file_name, line = match_data.captures

    lines = File.readlines(file_name).map(&:chomp)
    i = line.to_i - 1

    lines[i] << "<b> <---------- What were you thinking?</b>"

    3.times do
      i -= 1 if i > 0
    end

    lines[i, 6].join('<br>')
  end

end
