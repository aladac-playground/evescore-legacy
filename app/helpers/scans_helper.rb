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
  def selected_system(system_id)
    if params[:q]
      if params[:q][:solar_system_id_eq] and  params[:q][:solar_system_id_eq] == system_id
        return true
      end
    end
  end
  def checked_group(group_id)
    if params[:q]
      if params[:q][:sig_group_id_in] and params[:q][:sig_group_id_in].include?(group_id.to_s) 
        return true
      end
    end
  end
  def current_system
    if request.headers["HTTP_EVE_SOLARSYSTEMNAME"]
      request.headers["HTTP_EVE_SOLARSYSTEMNAME"]
    end
  end
  def current_system?
    if params[:q]
      if params[:q][:system_id_eq] == "current"
        puts "current1"
        return true
      end
    elsif
      session[:q]
      if session[:q][:system_id_eq] == "current"
        puts "current1"
        return true
      end
    end
  end
end
