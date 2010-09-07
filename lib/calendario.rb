# Calendario
module Calendario
  def calendario(year,month,action,eventos)
    
    h_eventos = Hash.new
    eventos.each do |evento|
      h_eventos[evento[0].to_date.strftime('%d-%m-%Y').to_s] = Array.new if h_eventos[evento[0].strftime('%d-%m-%Y').to_s].blank?
      h_eventos[evento[0].to_date.strftime('%d-%m-%Y').to_s] << [evento[1],evento[2],evento[3],evento[0].strftime('%H:%M')]
    end
    logger.info h_eventos.inspect
    
    month = month.to_i
    year  = year.to_i
    
    if month == 13
        year += 1 
        month = 1
    elsif month == 0
       year -= 1
       month = 12
    end
    
    str = "<div class='calendario_header' align='center'><span style='float: left;'><a href='http://#{request.host}:#{request.port}/#{action}/#{year.to_i}_#{month.to_i - 1}/listar'><img src='/images/anterior.png'/></a></span>#{Date.civil(year.to_i,month.to_i).strftime('%B')} - #{Date.civil(year.to_i,month.to_i).strftime('%Y')}<span style='float: right;'><a href='http://#{request.host}:#{request.port}/#{action}/#{year.to_i}_#{month.to_i + 1}/listar'><img src='/images/proximo.png'/></a></span></div>"
    str += "<table class='calendario'  cellspacing='0px' cellpading='0px'>"
    str += "<tr valign='middle'><th>Segunda</th><th>Terça</th><th>Quarta</th><th>Quinta</th><th>Sexta</th><th>Sábado</th><th>Domingo</th></tr>"
    
    str += "<tr class='line_calendario'>"
    Date.civil(year.to_i,month.to_i).at_beginning_of_month.at_beginning_of_week.upto(Date.civil(year.to_i,month.to_i).end_of_month) do |day|
      if(day.wday == 0)
        str += "<td style='width: 14%;'><div  id='#{((day.to_date == Date.today) ? 'today' : '')}' class='row_calendario'><div class='topo'>#{day.day}</div>#{adicionar_evento_calendario(format('%0.2d',day.day),format('%0.2d',month),year,h_eventos,action)}</div></div></td></tr><tr class='line_calendario'>"
      else
        str += "<td style='width: 14%;'><div id='#{((day.to_date == Date.today) ? 'today' : '')}' class='row_calendario'><div class='topo'>#{day.day}</div>#{adicionar_evento_calendario(format('%0.2d',day.day),format('%0.2d',month),day.year,h_eventos,action)}</div></td>"
      end
    end
    str += "</tr></table><script type='text/javascript'></script>"
  end
  
  def adicionar_evento_calendario(day,month,year,hash,action)
    str = ""

    unless hash["#{day}-#{month}-#{year}"].blank?
      hash["#{day}-#{month}-#{year}"].each do |evento|
        str += "<div class='evento'><a href='/#{action}/#{evento[2]}' class='event_link' title='#{evento[1]}'>#{evento[3]} - #{evento[0]}</a></div>"
      end
    end

    str
  end
end
