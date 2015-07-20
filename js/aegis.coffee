"use strict"

a_current_row     = undefined
a_current_sidebar = undefined
a_current_widget  = undefined
a_button_upload   = undefined
a_media           = undefined


jQuery(document).ready ->
  AegisUI.initColorPicker()
  AegisUI.initMediaCenter()

  Aegis.initSortableWidget()
  Aegis.initSortableColumn()
  Aegis.initSortableRow()
  
  Aegis.initDialogGrid()
  Aegis.initDialogWidgets()
  Aegis.initDialogSingleWidget()
  Aegis.initDialogRowCustomize()

  Aegis.initDialogGridAction()
  Aegis.initDialogSingleWidgetAction()

  Aegis.initGridAction()
  Aegis.initRowAction()
  Aegis.initColumnAction()
  Aegis.initWidgetAction()

  Aegis.initTabs()
  return

jQuery(window).load ->
	return

jQuery(document).ajaxSuccess ($) ->
  AegisUI.initColorPicker()
  AegisUI.initMediaCenter()  
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
      title: aegis_json.i18n.elements    
      width: 850
      height: 480
      modal: true
      autoOpen: false
    return
  
  initDialogWidgets: ->
    jQuery('#a_modal_widgets').dialog
      title: aegis_json.i18n.elements    
      width: 850
      height: 500
      modal: true
      autoOpen: false
    return

  initDialogRowCustomize: ->
    jQuery('#a_modal_row_customize').dialog
      title: aegis_json.i18n.row_customize    
      width: 850
      height: 500
      modal: true
      autoOpen: false
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

  initDialogSingleWidget: ->
    jQuery('#a_modal_single_widget').dialog
      title: ''    
      width: 850
      height: 500
      modal: true
      autoOpen: false
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
    jQuery('#aegis_metabox').on 'click', '.a_column_add_widget', ()->
      a_current_sidebar = jQuery(this).parents('.a_column_item').find('.a_block_wrap')
      jQuery('#a_modal_widgets').dialog 'open'
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
      AegisAjax.getWidgetForm(widget_id, widget_title, widget_class_name)
      return    
    return

  getRowTemplate: ->
    template = '<div id="' + Aegis.getRandomId(aegis_json.key.row + '_') + '" class="a_grid_item" data-index="0">'
    template += '<div class="a_header a_clearfix">'
    template += '<span class="a_action a_hanle a_row_hanle a_pull_left"><i class="ti-split-v"></i></span>'
    template += '<span class="a_action a_row_style a_pull_left"><i class="ti-layout-column3"></i></span>'         
    template += '<span class="a_action a_close a_row_close a_pull_right"><i class="ti-trash"></i></span>'
    template += '<span class="a_action a_row_customize a_pull_right"><i class="ti-paint-roller"></i></span>'
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
    template += '<span class="a_action a_hanle a_column_hanle a_pull_left"><i class="ti-split-v"></i></span>'
    template += '<span class="a_action a_column_add_widget a_pull_left"><i class="ti-package"></i></span>'
    template += '<span class="a_action a_column_customize a_pull_right"><i class="ti-paint-roller"></i></span>'
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
  initColorPicker: () ->
    color_pickers = jQuery('input.a_ui_color')
    if(color_pickers.length)
      color_pickers.wpColorPicker()    
    return

  initMediaCenter: () ->
    jQuery('.a_ui_image').on 'click', '.a_image_add', (event)->
      event.preventDefault()

      enliven_button_upload = jQuery this
          
      if (enliven_media)
        enliven_media.open()
        return      

      enliven_media = wp.media.frames.enliven_media = wp.media
        title:  aegis_json.i18n.media_center
        button:
          text: aegis_json.i18n.use 
        library:
          type: 'image'
        multiple: false               

      enliven_media.on 'select', () ->
        attachment = enliven_media.state().get('selection').first().toJSON()
        enliven_button_upload.parents('.a_ui_image').find('.a_image_url').val attachment.url        
        return        

      enliven_media.open()

      return  

    jQuery('.a_ui_image').on 'click', '.a_image_remove', (event)->
      event.preventDefault()
      jQuery(this).parents('.a_ui_image').find('.a_image_url').val ''
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
      success: (data, textStatus, jqXHR) ->    
        noty
          text: data
          theme: 'relax'
          layout: 'bottomRight'          
          type: 'success'
          timeout: 1000          
        return    

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
          return

    return

  saveRowCustomize: (event, form) ->
    event.preventDefault()
    form.ajaxSubmit
      success: (responseText, statusText, xhr, $form) ->
        if responseText
          noty
            text: responseText
            theme: 'relax'
            layout: 'bottomRight'          
            type: 'success'
            timeout: 1000            
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
          return
      
    return

  saveWidget: (event, form) ->
    event.preventDefault()
    form.ajaxSubmit
      success: (responseText, statusText, xhr, $form) ->
        if responseText
          a_current_sidebar.append responseText
          Aegis.initSortableWidget()
          Aegis.initSortableColumn()
          Aegis.initSortableRow()                  

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