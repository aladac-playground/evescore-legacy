module ApplicationHelper
  def section_title(title)
    content_tag(:table, class: "table table-striped section-title") do 
      content_tag(:tr) do
        content_tag(:th) do
          concat title
        end
      end
    end
  end
  
  def type_to_faction(rat_type)
    factions = [
      "Guristas",
      "Angel Cartel",
      "Blood Raiders",
      "Sansha's Nation",
      "Serpentis",
      "Caldari",
      "Minmatar",
      "Gallente",
      "Amarr",
      "CONCORD",
      "Concord"
    ]
    factions.each do |faction|
      if rat_type =~ /#{faction}/
        return faction
      end
    end
    return nil
  end
  def us(s)
    s.gsub(/\ /,"_")
  end

  def faction_image(rat_type, size=32, tooltip=nil)
    case rat_type
    when /Gurista/i
      url = "http://image.eveonline.com/Alliance/500010_#{size}.png"
    when /Sansha/i
      url = "http://image.eveonline.com/Alliance/500019_#{size}.png"
    when /Blood/i
      url = "http://image.eveonline.com/Corporation/1000134_#{size}.png"
    when /Serpentis/i
      url = "http://image.eveonline.com/Corporation/1000135_#{size}.png"
    when /Angel/i
      url = "http://image.eveonline.com/Alliance/500011_#{size}.png"
    when /Caldari/i
      url = "http://image.eveonline.com/Alliance/500001_#{size}.png"
    when /Minmatar/i
      url = "http://image.eveonline.com/Alliance/500002_#{size}.png"
    when /Amarr/i
      url = "http://image.eveonline.com/Alliance/500003_#{size}.png"
    when /Gallente/i
      url = "http://image.eveonline.com/Alliance/500004_#{size}.png"
    when /CONCORD/i
      url = "http://image.eveonline.com/Corporation/1000125_#{size}.png"
    end
    image_tag url, title: tooltip, class: :ttp, style: "display: inline"
  end 

  def damage_to_class(damage)
    case damage
    when /thermal/i
      "progress-bar-danger"
    when /kinetic/i
      "progress-bar-gray"
    when /explosive/i
      "progress-bar-warning"
    end
  end
  def nice_number(number, unit="", precision=0)
    number = 0 if number.nil?
    # number_with_delimiter(number_with_precision number, precision: 0)
    number_to_currency(number, precision: precision, unit: unit, format: "%n %u" )
  end
  def progress(percent, html_class=nil)
    content_tag(:div, class: "progress") do
      content_tag(:div, { class: "progress-bar #{html_class}", role: "progressbar", "aria-valuenow" => percent, "aria-valuemin" => 0, "aria-valuemax" => 100, style: "width: #{percent}%" }) do
        concat content_tag(:span, percent.to_s + "%")
      end
    end
  end 

  def rat_link(id, name, length=20)
    link_to truncate(name, length: length), "/rats/#{id}"
  end
  def char_link(id, name, length=20)
    link_to truncate(name, length: length), "/chars/#{id}"
  end
  def rat_info_ttp(id)
    rat = Rat.find(id)
    "<b>#{rat.name}</b><br><i>#{rat.rat_type}</i>".html_safe
  end
    
  def twocell(title, name, value, width=3)
    content_tag(:div, class: "col-lg-#{width}") do
      concat content_tag(:b, title, class: "top-title")
      concat(
      content_tag(:table, class: "table smaller-text") do
        content_tag(:tr) do
          concat content_tag(:td, name, class: :mh)
          concat content_tag(:td, value)
        end
      end
      )
    end
  end
    
  def eve_image(type, id, size=32, tooltip=nil, html_class=nil)
    base_url = "https://image.eveonline.com/"
    types = {
      type: { 
        path: "Type",
        image_type: "png"
      },
      alliance: { 
        path: "Alliance",
        image_type: "png"
      },
      corp: {
        path: "Corporation",
        image_type: "png"
      },
      char: {
        path: "Character",
        image_type: "jpg"
      },
    }
    
    if type == :rat
      type = :type
    end
    image_url = "#{base_url}/#{types[type][:path]}/#{id}_#{size}.#{types[type][:image_type]}"
    image_tag image_url, class: "inline img-rounded ttp #{html_class}", title: tooltip
  end
  def number_to_isk(amount)
    amount = 0 if amount.nil?
    if amount == 0 
      "-"
    else
      number_to_human(amount / 100, units: :isk, precision: 3, format: "%n%u ISK") 
    end
  end
  def this_month
    Time.now.at_beginning_of_month.strftime("%Y-%m")
  end
  def top_table(title, collection, type, numeric_type=:isk, width=3)
    content_tag(:div, class: "col-sm-#{width}") do
      concat content_tag(:h4, title, class: "top-title")
      concat(
      content_tag(:table, class: "table table-striped smaller-text vertical-middle") do
        content_tag(:tbody) do 
          collection.collect do |cell|
            concat(
              content_tag(:tr) do 
                concat(
                  content_tag(:td) do 
                    concat eve_image(type, cell.id)
                    concat ("&nbsp;" * 3).html_safe
                    # concat content_tag(:b, truncate(cell.name, length: width * 7 ), class: :ttp, title: cell.name)
                    case type
                    when :char
                      concat char_link(cell.id, cell.name, width * 7 )
                    when :type
                      concat rat_link(cell.id, cell.name, width * 7 )
                    end
                  end 
                )
                concat(
                  content_tag(:td, class: "numeric") do 
                    case numeric_type
                    when :isk
                      concat number_to_isk(cell.amount)
                    when :kill
                      concat number_with_delimiter(cell.amount) + " kills"
                    else
                      concat number_with_delimiter(cell.amount)
                    end
                  end 
                )
              end 
            )
          end
        end 
      end )
    end
  end
end
