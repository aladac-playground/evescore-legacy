module ScansHelper
  def type_to_color(sig_type)
    case sig_type 
    when /Combat/
      color="danger"
    when /Data/
      color="success"
    when /Relic/
      color="info"
    when /Ore/
      color="warn"
    when /Gas/
      color="white"
    when /Wormhole/
      color="yellow"
    end
    "<span class='text-#{color}'>#{sig_type}</span>".html_safe
  end
  def selected_system(system_id)
    if params[:q]
      if params[:q][:solar_system_id_eq] and params[:q][:solar_system_id_eq] == system_id
        return true
      end
      if params[:current_only] and request.headers["HTTP_EVE_SOLARSYSTEMID"] == system_id
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
