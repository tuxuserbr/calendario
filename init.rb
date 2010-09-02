# Include hook code here
require File.join(File.dirname(__FILE__), "lib", 'calendario')

ActionView::Base.send :include, Calendario

ActionController::Base.class_eval do
  def verificar_calendario
    begin
      @year = params[:id].split('_')[0].to_i
      @month = params[:id].split('_')[1].to_i
    rescue => e
      @month = (Time.now.month).to_i
      @year = (Time.now.year).to_i
    end
  end
end
