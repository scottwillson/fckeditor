# Fckeditor
module Fckeditor
  module Helper
    def fckeditor_textarea(object, field, options = {})
      var = instance_variable_get("@#{object}")
      if var
        value = var.send(field.to_sym)
        value = value.nil? ? "" : value
      else
        value = ""
        klass = "#{object}".camelcase.constantize
        instance_variable_set("@#{object}", eval("#{klass}.new()"))
      end
      id = fckeditor_element_id(object, field)
      
      cols = options[:cols].nil? ? '' : "cols='"+options[:cols]+"'"
      rows = options[:rows].nil? ? '' : "rows='"+options[:rows]+"'"
      
      width = options[:width].nil? ? '100%' : options[:width]
      height = options[:height].nil? ? '100%' : options[:height]
      
      toolbarSet = options[:toolbarSet].nil? ? 'Default' : options[:toolbarSet]
      
      if options[:ajax]
        inputs = "<input type='hidden' id='#{id}_hidden' name='#{object}[#{field}]'>\n" <<
                 "<textarea id='#{id}' #{cols} #{rows} name='#{id}'>#{value}</textarea>\n"
      else 
        inputs = "<textarea id='#{id}' #{cols} #{rows} name='#{object}[#{field}]'>#{value}</textarea>\n"
      end
      
      js_path = "/javascripts"
      base_path = "#{js_path}/fckeditor/"
      return inputs.html_safe <<
        javascript_tag("var oFCKeditor = new FCKeditor('#{id}', '#{width}', '#{height}', '#{toolbarSet}');\n" <<
                       "oFCKeditor.BasePath = \"#{base_path}\"\n" <<
                       "oFCKeditor.Config['CustomConfigurationsPath'] = '#{js_path}/fckcustom.js';\n" <<
                       "oFCKeditor.ReplaceTextarea();\n").html_safe
    end
    
    def fckeditor_form_remote_tag(options = {})
      editors = options[:editors]
      before = ""
      editors.keys.each do |e|
        editors[e].each do |f|
          before += fckeditor_before_js(e, f)
        end
      end
      options[:before] = options[:before].nil? ? before : before + options[:before] 
      form_remote_tag(options)
    end
    
    def fckeditor_remote_form_for(object_name, *args, &proc)
      options = args.last.is_a?(Hash) ? args.pop : {}
      concat(fckeditor_form_remote_tag(options), proc.binding)
      fields_for(object_name, *(args << options), &proc)
      concat('</form>', proc.binding)
    end
    alias_method :fckeditor_form_remote_for, :fckeditor_remote_form_for
    
    def fckeditor_element_id(object, field)
      id = eval("@#{object}.id")
      "#{object}_#{id}_#{field}_editor"    
    end

    def fckeditor_div_id(object, field)
      id = eval("@#{object}.id")  
      "div-#{object}-#{id}-#{field}-editor" 
    end

    def fckeditor_before_js(object, field)
      id = fckeditor_element_id(object, field)
      "var oEditor = FCKeditorAPI.GetInstance('"+id+"'); document.getElementById('"+id+"_hidden').value = oEditor.GetXHTML();"
    end    
  end
end

require 'railtie' if defined?(Rails)
