module ScansHelper
  def type_to_color(sig_type)
    case sig_type 
    when /Combat/
      html_class="danger"
    when /Data/
      html_class="primary"
    when /Relic/
      html_class="success"
    when /Ore/
      html_class="warning"
    when /Gas/
      html_class="info"
    when /Wormhole/
      html_class="yellow"
    end
    "<p class=\"text-#{html_class}\">#{sig_type}</p>".html_safe
  end
end
