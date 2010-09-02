# Calendario
module Calendario
  def calendario(year,month,model,atribute=nil)
    month = month.to_i
    year  = year.to_i
    
    if month == 13
        year += 1 
        month = 1
    elsif month == 0
       year -= 1
       month = 12
    end
    
    str = "<div class='calendario_header' align='center'><span style='float: left;'><a href='/#{model.to_s.downcase.pluralize}/#{year.to_i}_#{month.to_i - 1}/listar'><img src='/images/anterior.png'/></a></span>#{Date.civil(year.to_i,month.to_i).strftime('%B')} - #{Date.civil(year.to_i,month.to_i).strftime('%Y')}<span style='float: right;'><a href='/#{model.to_s.downcase.pluralize}/#{year.to_i}_#{month.to_i + 1}/listar'><img src='/images/proximo.png'/></a></span></div>"
    str += "<table class='calendario'  cellspacing='0px' cellpading='0px'>"
    str += "<tr valign='middle'><th>Segunda</th><th>Terça</th><th>Quarta</th><th>Quinta</th><th>Sexta</th><th>Sábado</th><th>Domingo</th></tr>"
    
    str += "<tr class='line_calendario'>"
    Date.civil(year.to_i,month.to_i).at_beginning_of_month.at_beginning_of_week.upto(Date.civil(year.to_i,month.to_i).end_of_month) do |day|
      if(day.wday == 0)
        logger.info "#{day.strftime('%d-%m-%Y')} #{Time.now.strftime("%d-%m-%Y")}"
        str += "<td style='width: 14%;'><div  id='#{((day.to_date == Date.today) ? 'today' : '')}' class='row_calendario'><div class='topo'>#{day.day}</div>#{adicionar_evento_calendario(day.day,month,year,model,atribute)}</div></div></td></tr><tr class='line_calendario'>"
      else
        str += "<td style='width: 14%;'><div id='#{((day.to_date == Date.today) ? 'today' : '')}' class='row_calendario'><div class='topo'>#{day.day}</div>#{adicionar_evento_calendario(day.day,day.month,day.year,model,atribute)}</div></td>"
      end
    end
    str += "</tr></table><script type='text/javascript'></script>"
  end
  
  def adicionar_evento_calendario(day,month,year,model,atribute)
    str = ""
    eval((model.to_s.singularize.camelize)).find(:all,:conditions=>["to_char(#{atribute.to_s},'yyyy-mm-dd') = '#{year}-#{format('%02d',month)}-#{format('%02d',day)}'"],:order => atribute.to_s).each do |evento|
      str += "<div class='evento'><a href='/events/#{evento.id}' class='event_link' title='#{evento.descricao}'>#{evento.start_at.strftime('%H:%M')} - #{evento.name}</a></div>"
    end
    str
  end
end
