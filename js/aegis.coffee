"use strict"

a_current_row     = undefined
a_current_col     = undefined
a_current_sidebar = undefined
a_current_widget  = undefined
a_button_upload   = undefined
a_media           = undefined


jQuery(document).ready ->
  jQuery('.a_tooltip').tooltipster({multiple: true})

  AegisUI.initColorPicker()
  AegisUI.initMediaCenter()

  Aegis.initSortableWidget()
  Aegis.initSortableColumn()
  Aegis.initSortableRow()
  
  Aegis.initDialogGrid()
  Aegis.initDialogWidgets()
  Aegis.initDialogSingleWidget()
  Aegis.initDialogRowCustomize()
  Aegis.initDialogColCustomize()

  Aegis.initDialogGridAction()
  Aegis.initDialogSingleWidgetAction()

  Aegis.initGridAction()
  Aegis.initRowAction()
  Aegis.initColumnAction()
  Aegis.initWidgetAction()

  Aegis.initTabs()
  return

jQuery(window).load ->
  AegisUI.openHelp()
  return

jQuery(document).ajaxSuccess ($) ->
  AegisUI.initColorPicker()
  AegisUI.initMediaCenter()
  jQuery('.a_tooltip').tooltipster({multiple: true})
  return  

Aegis =
  initSortableRow: ->
    jQuery('.a_row_wrap').sortable(
      connectWith: '.a_row_wrap'
      handle: '.a_row_hanle'
      start: (e, ui) ->
        ui.placeholder.height '48px'
        ui.placeholder.width '100px'
        return
      helper: ->
        '<span class="a_block_helper">Row</span>'
    ).disableSelection()
    return

  initSortableColumn: ->
    jQuery('.a_column_wrap').sortable(
      containment: 'parent'
      connectWith: '.a_column_wrap'
      handle: '.a_column_hanle'
      start: (e, ui) ->
        ui.placeholder.height '48px'
        ui.placeholder.width '100px'
        return
      helper: ->
        '<span class="a_block_helper">Column</span>'
    ).disableSelection()
    return

  initSortableWidget: ->
    jQuery('.a_block_wrap').sortable(
      connectWith: '.a_block_wrap'
      handle: '.a_block_hanle'
      start: (e, ui) ->
        ui.placeholder.height '48px'
        ui.placeholder.width '100px'
        return
      helper: ->
        '<span class="a_block_helper">Widget</span>'
    ).disableSelection()
    return

  initDialogGrid: ->
    jQuery('#a_modal_grid').dialog
      title: aegis_json.i18n.layouts
      dialogClass: 'a_fixed_dialog'
      width: 900
      height: 500
      modal: true
      autoOpen: false
      create: (event, ui)->
        widget = jQuery(this).dialog("widget")
        jQuery(".ui-dialog-titlebar-close", widget).html '<i class="ti ti-close"></i>'
        return      
    return
  
  initDialogWidgets: ->
    jQuery('#a_modal_widgets').dialog
      title: aegis_json.i18n.elements
      dialogClass: 'a_fixed_dialog'
      width: 900
      height: 500
      modal: true
      autoOpen: false
      create: (event, ui)->
        widget = jQuery(this).dialog("widget")
        jQuery(".ui-dialog-titlebar-close", widget).html '<i class="ti ti-close"></i>'
        return      
    return

  initDialogRowCustomize: ->
    jQuery('#a_modal_row_customize').dialog
      title: aegis_json.i18n.row_customize
      dialogClass: 'a_fixed_dialog'
      width: 900
      height: 500
      modal: true
      autoOpen: false
      create: (event, ui)->
        widget = jQuery(this).dialog("widget")
        jQuery(".ui-dialog-titlebar-close", widget).html '<i class="ti ti-close"></i>'
        return
      buttons:[
        {
          text: 'Save & Exit'
          'class': 'a_button_save_and_exit button button-secondary'
          click: ->
            jQuery('#a_modal_row_customize').submit()
            jQuery('#a_modal_row_customize').dialog 'close'
            return
        }
        {
          text: 'Save'
          'class': 'a_button_save button button-secondary'
          click: ->
            jQuery('#a_modal_row_customize').submit()            
            return
        }
      ]    
    
    return

  initDialogColCustomize: ->
    jQuery('#a_modal_col_customize').dialog
      title: aegis_json.i18n.col_customize
      dialogClass: 'a_fixed_dialog'
      width: 900
      height: 500
      modal: true
      autoOpen: false
      create: (event, ui)->
        widget = jQuery(this).dialog("widget")
        jQuery(".ui-dialog-titlebar-close", widget).html '<i class="ti ti-close"></i>'
        return
      buttons:[
        {
          text: aegis_json.i18n.save_and_exit
          'class': 'a_button_save_and_exit button button-secondary'
          click: ->
            jQuery('#a_modal_col_customize').submit()
            jQuery('#a_modal_col_customize').dialog 'close'
            return
        }
        {
          text: aegis_json.i18n.save
          'class': 'a_button_save button button-secondary'
          click: ->
            jQuery('#a_modal_col_customize').submit()            
            return
        }
      ]    
    
    return

  initDialogSingleWidget: ->
    jQuery('#a_modal_single_widget').dialog
      title: ''
      dialogClass: 'a_fixed_dialog'
      width: 900
      height: 500
      modal: true
      autoOpen: false
      create: (event, ui)->
        widget = jQuery(this).dialog("widget")
        jQuery(".ui-dialog-titlebar-close", widget).html '<i class="ti ti-close"></i>'
        return      
      buttons:[
        {
          text: 'Save & Exit'
          'class': 'a_button_save_and_exit button button-secondary'
          click: ->
            jQuery('#a_modal_single_widget').submit()
            jQuery('#a_modal_single_widget').dialog 'close'
            jQuery('#a_modal_single_widget').dialog 'option', 'title', ''
            return
        }
        {
          text: 'Save'
          'class': 'a_button_save button button-secondary'
          click: ->
            jQuery('#a_modal_single_widget').submit()            
            return
        }
      ]
    return

  initDialogGridAction: ->
    jQuery("#a_modal_grid").on 'click', '.a_row_mockup', ()->
      
      if(a_current_row != undefined)
        
        old_grid_index = parseInt(a_current_row.attr 'data-index')
        new_grid_index = parseInt(jQuery(this).attr 'data-index')
        a_current_row.attr 'data-index', new_grid_index
        jQuery('#a_modal_grid').dialog 'close'

        if(old_grid_index != new_grid_index)
          old_grid    = aegis_json.layouts[old_grid_index]
          new_grid    = aegis_json.layouts[new_grid_index]
          column_wrap = a_current_row.find '.a_column_wrap'

          if parseInt(old_grid.length) < parseInt(new_grid.length)
            # add new cols
            i = 0
            while i < new_grid.length - (old_grid.length)
              column_wrap.append Aegis.getColumnTemplate()
              i++

          else if parseInt(old_grid.length) > parseInt(new_grid.length)
            
            # move all widget to first column
            blocks      = column_wrap.find('.a_block')
            temp_blocks = {}

            if blocks.length
              temp_blocks = blocks.clone()

            # remove all column
            column_wrap.html ''
            jQuery.each new_grid, (index_2, item_2) ->
              column_wrap.append Aegis.getColumnTemplate()
              jQuery('.a_tooltip').tooltipster({multiple: true})
              return
            
            # add widget to first column
            if temp_blocks.length
              temp_blocks.appendTo column_wrap.find('.a_column_item_outer .a_block_wrap').first()

          cols = a_current_row.find('.a_column_item_outer')
          #resize all column
          i = 0
          while i < new_grid.length
            cols.eq(i).attr('class', '').addClass('a_column_item_outer').addClass 'a_col_' + new_grid[i]
            cols.eq(i).attr 'data-index', new_grid[i]
            i++

          Aegis.initSortableWidget()
          Aegis.initSortableColumn()
          Aegis.initSortableRow();
        
      return
    return

  initDialogSingleWidgetAction: ->
    jQuery("#a_modal_widgets").on 'click', '.a_item', (event)->
      jQuery('#a_modal_widgets').dialog 'close'
      widget_class_name = jQuery(this).find('input[name=a_widget_class_name]').val()
      widget_title      = jQuery(this).find('input[name=a_widget_title]').val()  
      widget_id         = Aegis.getRandomId(aegis_json.key.widget + '_');
      AegisAjax.getWidgetForm(widget_id, widget_title, widget_class_name)
      return
    return

  initGridAction: ->
    jQuery('#aegis_metabox').on 'click', '.a_save_all', (event)->
      event.preventDefault()      
      AegisAjax.saveAll()
      return
    return

  initRowAction: ->
    jQuery("#aegis_metabox").on 'click', '.a_row_style', (event)->
      event.preventDefault()
      a_current_row = jQuery(this).parents('.a_grid_item')       
      jQuery('#a_modal_grid').dialog 'open'
      return

    jQuery('#aegis_metabox').on 'click', '.a_add_row', (event)->
      event.preventDefault()
      jQuery('#aegis_metabox .a_row_wrap').append Aegis.getRowTemplate()
      Aegis.initSortableWidget()
      Aegis.initSortableColumn()
      Aegis.initSortableRow();
      jQuery('.a_tooltip').tooltipster({multiple: true})
      return

    jQuery('#aegis_metabox').on 'click', '.a_row_close', (event)->
      event.preventDefault()
      answer = confirm('Are you sure to remove this row?')
      if true == answer
        jQuery(this).parents('.a_grid_item').remove()
        AegisAjax.saveAll()
      return

    jQuery('#aegis_metabox').on 'click', '.a_row_customize', (event)->
      event.preventDefault()
      a_current_row = jQuery(this).parents('.a_grid_item')
      row_id        = a_current_row.attr 'id'
      AegisAjax.getRowCustomizeForm(row_id)
      return

    return

  initColumnAction: ->
    jQuery('#aegis_metabox').on 'click', '.a_column_add_widget', (event)->
      event.preventDefault()
      a_current_sidebar = jQuery(this).parents('.a_column_item').find('.a_block_wrap')
      jQuery('#a_modal_widgets').dialog 'open'
      jQuery('.a_tooltip').tooltipster({multiple: true})
      return

    jQuery('#aegis_metabox').on 'click', '.a_col_customize', (event)->
      event.preventDefault()
      a_current_col = jQuery(this).parents('.a_column_item_outer')
      col_id        = a_current_col.attr 'id'
      AegisAjax.getColCustomizeForm(col_id)
      return

    return

  initWidgetAction: ->
    jQuery('#aegis_metabox').on 'click', '.a_block_close', (event)->
      event.preventDefault()
      answer = confirm('Are you sure to remove this widget?')
      if true == answer
        AegisAjax.removeWidget(jQuery(this))
      return

    jQuery('#aegis_metabox').on 'click', '.a_block_edit', (event)->
      event.preventDefault()      
      widget            = jQuery(this).parents('.a_block')
      widget_id         = widget.attr 'id'
      widget_title      = jQuery.trim(widget.find('.a_body').html())
      widget_class_name = ''
      a_current_sidebar = widget.parents '.a_block_wrap'
      a_current_widget  = widget
      AegisAjax.getWidgetForm(widget_id, widget_title, widget_class_name)
      return
    return

  getRowTemplate: ->
    template = '<div id="' + Aegis.getRandomId(aegis_json.key.row + '_') + '" class="a_grid_item" data-index="0">'
    template += '<div class="a_header a_clearfix">'
    template += '<span class="a_action a_hanle a_row_hanle a_pull_left a_tooltip" title="' + aegis_json.i18n.drag_row_to_reorder + '"><i class="ti-split-v"></i></span>'
    template += '<span class="a_action a_row_style a_pull_left a_tooltip" title="' + aegis_json.i18n.split_row_to_multi_columns + '"><i class="ti-layout-column3"></i></span>'         
    template += '<span class="a_action a_row_customize a_pull_left a_tooltip" title="' + aegis_json.i18n.edit_this_row + '"><i class="ti-pencil"></i></span>'
    template += '<span class="a_action a_close a_row_close a_pull_right a_tooltip" title="' + aegis_json.i18n.delete_this_row + '"><i class="ti-trash"></i></span>'    
    template += '</div>'
    template += '<div class="a_body a_clearfix">'
    template += '<div class="a_column_wrap a_row a_clearfix">'
    template += Aegis.getColumnTemplate()
    template += '</div>'
    template += '</div>'
    template += '</div>'
    return template

  getColumnTemplate: ->
    template = '<div id="' + Aegis.getRandomId(aegis_json.key.col + '_') + '" class="a_column_item_outer a_col_12" data-index="12">'
    template += '<div class="a_column_item">'
    template += '<div class="a_header a_clearfix">'
    template += '<span class="a_action a_hanle a_column_hanle a_pull_left a_tooltip" title="' + aegis_json.i18n.drag_column_to_reorder + '"><i class="ti-split-v"></i></span>'
    template += '<span class="a_action a_column_add_widget a_pull_left a_tooltip" title="' + aegis_json.i18n.insert_new_widget_to_this_column + '"><i class="ti-package"></i></span>'
    template += '<span class="a_action a_col_customize a_pull_left a_tooltip" title="' + aegis_json.i18n.edit_this_column + '"><i class="ti-pencil"></i></span>'
    template += '</div>'
    template += '<div class="a_block_wrap a_body a_clearfix">'
    template += '</div>'
    template += '</div>'
    template += '</div>'
    return template

  getRandomId: (prefix) ->
    prefix + Math.random().toString(36).substr(2)

  initTabs: ->
    tabs = jQuery('.a_tabs')
    if tabs.length
      tabs.on 'click', '.a_tab_item', (event)->
        event.preventDefault()
        if !jQuery(this).hasClass 'a_active'
          jQuery(this).parent().find('.a_tab_item').removeClass 'a_active'
          jQuery(this).addClass 'a_active'
          tab_content_id = jQuery(this).find('span').attr 'data-tab-id'
          jQuery(this).parents('.a_tabs').find('.a_tab_content.a_active').removeClass('a_active').addClass('a_hide')
          jQuery(tab_content_id).removeClass('a_hide').addClass('a_active')

        return
    return

AegisUI =
  alert: (message) ->
    jQuery.amaran
      message: message
      position: 'bottom right'
      inEffect: 'slideRight'
    return

  initColorPicker: () ->
    color_pickers = jQuery('input.a_ui_color')
    if(color_pickers.length)
      color_pickers.wpColorPicker()    
    return

  initMediaCenter: () ->
    jQuery('.a_ui_image').on 'click', '.a_image_add', (event)->
      event.preventDefault()

      a_button_upload = jQuery this
          
      if (a_media)
        a_media.open()
        return      

      a_media = wp.media.frames.a_media = wp.media
        title:  aegis_json.i18n.media_center
        button:
          text: aegis_json.i18n.use 
        library:
          type: 'image'
        multiple: false               

      a_media.on 'select', () ->
        attachment = a_media.state().get('selection').first().toJSON()
        a_button_upload.parents('.a_ui_image').find('.a_image_url').val attachment.url        
        return        

      a_media.open()

      return  

    jQuery('.a_ui_image').on 'click', '.a_image_remove', (event)->
      event.preventDefault()
      jQuery(this).parents('.a_ui_image').find('.a_image_url').val ''
      return

    return  

  openHelp: ()->
    jQuery('body').on 'click', '.a_desc_handler', (event)->
      event.preventDefault()
      $desc = jQuery(this).next()
      if $desc.hasClass('a_hide')
        $desc.removeClass('a_hide').addClass('a_active')
      else
        $desc.removeClass('a_active').addClass('a_hide')
      return
    
    return

AegisAjax =

  saveAll:->
    data = 
      rows: []      

    rows = jQuery('.a_grid_item')
    
    if(rows.length)
      rows.each (r_index, r_element) ->
        current_row = jQuery r_element
        row_data    = 
          id: current_row.attr 'id'
          index: current_row.attr 'data-index'
          cols: []

        cols = current_row.find '.a_column_item_outer'
        if(cols.length)
          cols.each (c_index, c_element) ->
            current_col = jQuery c_element
            col_data    = 
              id: current_col.attr 'id'
              index: current_col.attr 'data-index'
              widgets: []

            widgets = current_col.find '.a_block'
            if(widgets.length)
              widgets.each (w_index, w_element) ->
                current_widget = jQuery w_element
                widget_data    = 
                  id: current_widget.attr 'id'
                  name: jQuery.trim current_widget.find('.a_body').html()
                col_data.widgets.push widget_data
                return
            
            row_data.cols.push col_data
            return
        
        data.rows.push row_data          
        return
    
    jQuery.ajax
      url: aegis_json.ajax
      dataType: "html"
      type: 'POST'
      async: true
      data:          
        data: data
        action: 'aegis_save_all'
        security: jQuery('#aegis_save_all_security').val()
        post_id: parseInt(jQuery('#post_ID').val())
      success: (responseText, textStatus, jqXHR) ->    
        #NOTY        
        AegisUI.alert(responseText)

    return

  getRowCustomizeForm: (row_id)->
    if(a_current_row)
      jQuery.ajax
        url: aegis_json.ajax
        dataType: "html"
        type: 'POST'
        async: true
        data:                
          action: 'aegis_get_row_customize_form'
          security: jQuery('#aegis_get_row_customize_form_security').val()
          post_id: parseInt(jQuery('#post_ID').val())
          row_id: row_id
        success: (data, textStatus, jqXHR) ->
          jQuery('#a_modal_row_customize .a_row_customize_form').html data
          jQuery('#a_modal_row_customize input[name=a_row_id]').val row_id
          jQuery('#a_modal_row_customize').dialog 'open'
          jQuery('.a_tooltip').tooltipster({multiple: true, contentAsHTML: true, theme: 'tooltipster-punk', position: 'top-right'})
          return

    return

  saveRowCustomize: (event, form) ->
    event.preventDefault()
    form.ajaxSubmit
      success: (responseText, statusText, xhr, $form) ->
        if responseText
          #NOTY          
          AegisUI.alert(responseText)       
        return    
    return

  getColCustomizeForm: (col_id)->
    if(a_current_col)
      jQuery.ajax
        url: aegis_json.ajax
        dataType: "html"
        type: 'POST'
        async: true
        data:                
          action: 'aegis_get_col_customize_form'
          security: jQuery('#aegis_get_col_customize_form_security').val()
          post_id: parseInt(jQuery('#post_ID').val())
          col_id: col_id
        success: (data, textStatus, jqXHR) ->
          jQuery('#a_modal_col_customize .a_col_customize_form').html data
          jQuery('#a_modal_col_customize input[name=a_col_id]').val col_id
          jQuery('#a_modal_col_customize').dialog 'open'
          jQuery('.a_tooltip').tooltipster({multiple: true, contentAsHTML: true, theme: 'tooltipster-punk', position: 'top-right'})
          return

    return

  saveColCustomize: (event, form) ->
    event.preventDefault()
    form.ajaxSubmit
      success: (responseText, statusText, xhr, $form) ->
        if responseText
          #NOTY
          AegisUI.alert(responseText)
        return    
    return

  getWidgetForm: (widget_id, widget_title, widget_class_name) ->
    if(a_current_sidebar)
      jQuery.ajax
        url: aegis_json.ajax
        dataType: "html"
        type: 'POST'
        async: true
        data:
          widget_class_name: widget_class_name
          widget_title: widget_title   
          widget_id: widget_id       
          action: 'aegis_get_widget_form'
          security: jQuery('#aegis_get_widget_form_security').val()
          post_id: parseInt(jQuery('#post_ID').val())          
        success: (data, textStatus, jqXHR) ->
          jQuery('#a_modal_single_widget .a_widget_form').html data          
          jQuery('#a_modal_single_widget input[name=a_widget_class_name]').val widget_class_name
          jQuery('#a_modal_single_widget input[name=a_widget_title]').val widget_title
          jQuery('#a_modal_single_widget input[name=a_widget_id]').val widget_id
          jQuery('#a_modal_single_widget').dialog 'option', 'title', widget_title
          jQuery('#a_modal_single_widget').dialog 'open'
          jQuery('.a_tooltip').tooltipster({multiple: true, contentAsHTML: true, theme: 'tooltipster-punk', position: 'top-right'})
          return
      
    return

  saveWidget: (event, form) ->
    event.preventDefault()
    form.ajaxSubmit
      dataType: 'json'
      success: (responseText, statusText, xhr, $form) ->        
        if (1 == responseText.is_first)
          a_current_sidebar.append(responseText.html)
          Aegis.initSortableWidget()
          Aegis.initSortableColumn()
          Aegis.initSortableRow()        
        else
          a_current_widget.find('.a_body').html(responseText.html)          
          a_current_widget = undefined
        AegisAjax.saveAll()
        return
    return

  removeWidget: (button_remove) ->
    widget = button_remove.parents('.a_block')
    jQuery.ajax
      url: aegis_json.ajax
      dataType: "html"
      type: 'POST'
      async: true
      data:          
        widget_id: widget.attr('id')
        action: 'aegis_remove_widget'
        security: jQuery('#aegis_remove_widget_security').val()
        post_id: parseInt(jQuery('#post_ID').val())
      success: (data, textStatus, jqXHR) ->
        widget.remove()
        AegisAjax.saveAll()
        return
    return