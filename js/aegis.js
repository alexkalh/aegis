"use strict";
var Aegis, AegisAjax, AegisUI, a_button_upload, a_current_col, a_current_row, a_current_sidebar, a_current_widget, a_media;

a_current_row = void 0;

a_current_col = void 0;

a_current_sidebar = void 0;

a_current_widget = void 0;

a_button_upload = void 0;

a_media = void 0;

jQuery(document).ready(function() {
  jQuery('.tooltip').tooltipster({
    multiple: true
  });
  AegisUI.initColorPicker();
  AegisUI.initMediaCenter();
  Aegis.initSortableWidget();
  Aegis.initSortableColumn();
  Aegis.initSortableRow();
  Aegis.initDialogGrid();
  Aegis.initDialogWidgets();
  Aegis.initDialogSingleWidget();
  Aegis.initDialogRowCustomize();
  Aegis.initDialogColCustomize();
  Aegis.initDialogGridAction();
  Aegis.initDialogSingleWidgetAction();
  Aegis.initGridAction();
  Aegis.initRowAction();
  Aegis.initColumnAction();
  Aegis.initWidgetAction();
  Aegis.initTabs();
});

jQuery(window).load(function() {});

jQuery(document).ajaxSuccess(function($) {
  AegisUI.initColorPicker();
  AegisUI.initMediaCenter();
  jQuery('.tooltip').tooltipster({
    multiple: true
  });
});

Aegis = {
  initSortableRow: function() {
    jQuery('.a_row_wrap').sortable({
      connectWith: '.a_row_wrap',
      handle: '.a_row_hanle',
      start: function(e, ui) {
        ui.placeholder.height('48px');
        ui.placeholder.width('100px');
      },
      helper: function() {
        return '<span class="a_block_helper">Row</span>';
      }
    }).disableSelection();
  },
  initSortableColumn: function() {
    jQuery('.a_column_wrap').sortable({
      connectWith: '.a_column_wrap',
      handle: '.a_column_hanle',
      start: function(e, ui) {
        ui.placeholder.height('48px');
        ui.placeholder.width('100px');
      },
      helper: function() {
        return '<span class="a_block_helper">Column</span>';
      }
    }).disableSelection();
  },
  initSortableWidget: function() {
    jQuery('.a_block_wrap').sortable({
      connectWith: '.a_block_wrap',
      handle: '.a_block_hanle',
      start: function(e, ui) {
        ui.placeholder.height('48px');
        ui.placeholder.width('100px');
      },
      helper: function() {
        return '<span class="a_block_helper">Widget</span>';
      }
    }).disableSelection();
  },
  initDialogGrid: function() {
    jQuery('#a_modal_grid').dialog({
      title: aegis_json.i18n.layouts,
      dialogClass: 'a_fixed_dialog',
      width: 900,
      height: 500,
      modal: true,
      autoOpen: false,
      create: function(event, ui) {
        var widget;
        widget = jQuery(this).dialog("widget");
        jQuery(".ui-dialog-titlebar-close", widget).html('<i class="ti ti-close"></i>');
      }
    });
  },
  initDialogWidgets: function() {
    jQuery('#a_modal_widgets').dialog({
      title: aegis_json.i18n.elements,
      dialogClass: 'a_fixed_dialog',
      width: 900,
      height: 500,
      modal: true,
      autoOpen: false,
      create: function(event, ui) {
        var widget;
        widget = jQuery(this).dialog("widget");
        jQuery(".ui-dialog-titlebar-close", widget).html('<i class="ti ti-close"></i>');
      }
    });
  },
  initDialogRowCustomize: function() {
    jQuery('#a_modal_row_customize').dialog({
      title: aegis_json.i18n.row_customize,
      dialogClass: 'a_fixed_dialog',
      width: 900,
      height: 500,
      modal: true,
      autoOpen: false,
      create: function(event, ui) {
        var widget;
        widget = jQuery(this).dialog("widget");
        jQuery(".ui-dialog-titlebar-close", widget).html('<i class="ti ti-close"></i>');
      },
      buttons: [
        {
          text: 'Save & Exit',
          'class': 'a_button_save_and_exit button button-secondary',
          click: function() {
            jQuery('#a_modal_row_customize').submit();
            jQuery('#a_modal_row_customize').dialog('close');
          }
        }, {
          text: 'Save',
          'class': 'a_button_save button button-secondary',
          click: function() {
            jQuery('#a_modal_row_customize').submit();
          }
        }
      ]
    });
  },
  initDialogColCustomize: function() {
    jQuery('#a_modal_col_customize').dialog({
      title: aegis_json.i18n.col_customize,
      dialogClass: 'a_fixed_dialog',
      width: 900,
      height: 500,
      modal: true,
      autoOpen: false,
      create: function(event, ui) {
        var widget;
        widget = jQuery(this).dialog("widget");
        jQuery(".ui-dialog-titlebar-close", widget).html('<i class="ti ti-close"></i>');
      },
      buttons: [
        {
          text: aegis_json.i18n.save_and_exit,
          'class': 'a_button_save_and_exit button button-secondary',
          click: function() {
            jQuery('#a_modal_col_customize').submit();
            jQuery('#a_modal_col_customize').dialog('close');
          }
        }, {
          text: aegis_json.i18n.save,
          'class': 'a_button_save button button-secondary',
          click: function() {
            jQuery('#a_modal_col_customize').submit();
          }
        }
      ]
    });
  },
  initDialogSingleWidget: function() {
    jQuery('#a_modal_single_widget').dialog({
      title: '',
      dialogClass: 'a_fixed_dialog',
      width: 900,
      height: 500,
      modal: true,
      autoOpen: false,
      create: function(event, ui) {
        var widget;
        widget = jQuery(this).dialog("widget");
        jQuery(".ui-dialog-titlebar-close", widget).html('<i class="ti ti-close"></i>');
      },
      buttons: [
        {
          text: 'Save & Exit',
          'class': 'a_button_save_and_exit button button-secondary',
          click: function() {
            jQuery('#a_modal_single_widget').submit();
            jQuery('#a_modal_single_widget').dialog('close');
            jQuery('#a_modal_single_widget').dialog('option', 'title', '');
          }
        }, {
          text: 'Save',
          'class': 'a_button_save button button-secondary',
          click: function() {
            jQuery('#a_modal_single_widget').submit();
          }
        }
      ]
    });
  },
  initDialogGridAction: function() {
    jQuery("#a_modal_grid").on('click', '.a_row_mockup', function() {
      var blocks, cols, column_wrap, i, new_grid, new_grid_index, old_grid, old_grid_index, temp_blocks;
      if (a_current_row !== void 0) {
        old_grid_index = parseInt(a_current_row.attr('data-index'));
        new_grid_index = parseInt(jQuery(this).attr('data-index'));
        a_current_row.attr('data-index', new_grid_index);
        jQuery('#a_modal_grid').dialog('close');
        if (old_grid_index !== new_grid_index) {
          old_grid = aegis_json.layouts[old_grid_index];
          new_grid = aegis_json.layouts[new_grid_index];
          column_wrap = a_current_row.find('.a_column_wrap');
          if (parseInt(old_grid.length) < parseInt(new_grid.length)) {
            i = 0;
            while (i < new_grid.length - old_grid.length) {
              column_wrap.append(Aegis.getColumnTemplate());
              i++;
            }
          } else if (parseInt(old_grid.length) > parseInt(new_grid.length)) {
            blocks = column_wrap.find('.a_block');
            temp_blocks = {};
            if (blocks.length) {
              temp_blocks = blocks.clone();
            }
            column_wrap.html('');
            jQuery.each(new_grid, function(index_2, item_2) {
              column_wrap.append(Aegis.getColumnTemplate());
              jQuery('.tooltip').tooltipster({
                multiple: true
              });
            });
            if (temp_blocks.length) {
              temp_blocks.appendTo(column_wrap.find('.a_column_item_outer .a_block_wrap').first());
            }
          }
          cols = a_current_row.find('.a_column_item_outer');
          i = 0;
          while (i < new_grid.length) {
            cols.eq(i).attr('class', '').addClass('a_column_item_outer').addClass('a_col_' + new_grid[i]);
            cols.eq(i).attr('data-index', new_grid[i]);
            i++;
          }
          Aegis.initSortableWidget();
          Aegis.initSortableColumn();
          Aegis.initSortableRow();
        }
      }
    });
  },
  initDialogSingleWidgetAction: function() {
    jQuery("#a_modal_widgets").on('click', '.a_item', function(event) {
      var widget_class_name, widget_id, widget_title;
      jQuery('#a_modal_widgets').dialog('close');
      widget_class_name = jQuery(this).find('input[name=a_widget_class_name]').val();
      widget_title = jQuery(this).find('input[name=a_widget_title]').val();
      widget_id = Aegis.getRandomId(aegis_json.key.widget + '_');
      AegisAjax.getWidgetForm(widget_id, widget_title, widget_class_name);
    });
  },
  initGridAction: function() {
    jQuery('#aegis_metabox').on('click', '.a_save_all', function(event) {
      event.preventDefault();
      AegisAjax.saveAll();
    });
  },
  initRowAction: function() {
    jQuery("#aegis_metabox").on('click', '.a_row_style', function(event) {
      event.preventDefault();
      a_current_row = jQuery(this).parents('.a_grid_item');
      jQuery('#a_modal_grid').dialog('open');
    });
    jQuery('#aegis_metabox').on('click', '.a_add_row', function(event) {
      event.preventDefault();
      jQuery('#aegis_metabox .a_row_wrap').append(Aegis.getRowTemplate());
      Aegis.initSortableWidget();
      Aegis.initSortableColumn();
      Aegis.initSortableRow();
      jQuery('.tooltip').tooltipster({
        multiple: true
      });
    });
    jQuery('#aegis_metabox').on('click', '.a_row_close', function(event) {
      var answer;
      event.preventDefault();
      answer = confirm('Are you sure to remove this row?');
      if (true === answer) {
        jQuery(this).parents('.a_grid_item').remove();
        AegisAjax.saveAll();
      }
    });
    jQuery('#aegis_metabox').on('click', '.a_row_customize', function(event) {
      var row_id;
      event.preventDefault();
      a_current_row = jQuery(this).parents('.a_grid_item');
      row_id = a_current_row.attr('id');
      AegisAjax.getRowCustomizeForm(row_id);
    });
  },
  initColumnAction: function() {
    jQuery('#aegis_metabox').on('click', '.a_column_add_widget', function() {
      a_current_sidebar = jQuery(this).parents('.a_column_item').find('.a_block_wrap');
      jQuery('#a_modal_widgets').dialog('open');
    });
    jQuery('#aegis_metabox').on('click', '.a_col_customize', function(event) {
      var col_id;
      event.preventDefault();
      a_current_col = jQuery(this).parents('.a_column_item_outer');
      col_id = a_current_col.attr('id');
      AegisAjax.getColCustomizeForm(col_id);
    });
  },
  initWidgetAction: function() {
    jQuery('#aegis_metabox').on('click', '.a_block_close', function(event) {
      var answer;
      event.preventDefault();
      answer = confirm('Are you sure to remove this widget?');
      if (true === answer) {
        AegisAjax.removeWidget(jQuery(this));
      }
    });
    jQuery('#aegis_metabox').on('click', '.a_block_edit', function(event) {
      var widget, widget_class_name, widget_id, widget_title;
      event.preventDefault();
      widget = jQuery(this).parents('.a_block');
      widget_id = widget.attr('id');
      widget_title = jQuery.trim(widget.find('.a_body').html());
      widget_class_name = '';
      a_current_sidebar = widget.parents('.a_block_wrap');
      AegisAjax.getWidgetForm(widget_id, widget_title, widget_class_name);
    });
  },
  getRowTemplate: function() {
    var template;
    template = '<div id="' + Aegis.getRandomId(aegis_json.key.row + '_') + '" class="a_grid_item" data-index="0">';
    template += '<div class="a_header a_clearfix">';
    template += '<span class="a_action a_hanle a_row_hanle a_pull_left tooltip" title="' + aegis_json.i18n.drag_row_to_reorder + '"><i class="ti-split-v"></i></span>';
    template += '<span class="a_action a_row_style a_pull_left tooltip" title="' + aegis_json.i18n.split_row_to_multi_columns + '"><i class="ti-layout-column3"></i></span>';
    template += '<span class="a_action a_row_customize a_pull_left tooltip" title="' + aegis_json.i18n.edit_this_row + '"><i class="ti-pencil"></i></span>';
    template += '<span class="a_action a_close a_row_close a_pull_right tooltip" title="' + aegis_json.i18n.delete_this_row + '"><i class="ti-trash"></i></span>';
    template += '</div>';
    template += '<div class="a_body a_clearfix">';
    template += '<div class="a_column_wrap a_row a_clearfix">';
    template += Aegis.getColumnTemplate();
    template += '</div>';
    template += '</div>';
    template += '</div>';
    return template;
  },
  getColumnTemplate: function() {
    var template;
    template = '<div id="' + Aegis.getRandomId(aegis_json.key.col + '_') + '" class="a_column_item_outer a_col_12" data-index="12">';
    template += '<div class="a_column_item">';
    template += '<div class="a_header a_clearfix">';
    template += '<span class="a_action a_hanle a_column_hanle a_pull_left tooltip" title="' + aegis_json.i18n.drag_column_to_reorder + '"><i class="ti-split-v"></i></span>';
    template += '<span class="a_action a_column_add_widget a_pull_left tooltip" title="' + aegis_json.i18n.insert_new_widget_to_this_column + '"><i class="ti-package"></i></span>';
    template += '<span class="a_action a_column_customize a_pull_left tooltip" title="' + aegis_json.i18n.edit_this_column + '"><i class="ti-pencil"></i></span>';
    template += '</div>';
    template += '<div class="a_block_wrap a_body a_clearfix">';
    template += '</div>';
    template += '</div>';
    template += '</div>';
    return template;
  },
  getRandomId: function(prefix) {
    return prefix + Math.random().toString(36).substr(2);
  },
  initTabs: function() {
    var tabs;
    tabs = jQuery('.a_tabs');
    if (tabs.length) {
      tabs.on('click', '.a_tab_item', function(event) {
        var tab_content_id;
        event.preventDefault();
        if (!jQuery(this).hasClass('a_active')) {
          jQuery(this).parent().find('.a_tab_item').removeClass('a_active');
          jQuery(this).addClass('a_active');
          tab_content_id = jQuery(this).find('span').attr('data-tab-id');
          jQuery(this).parents('.a_tabs').find('.a_tab_content.a_active').removeClass('a_active').addClass('a_hide');
          jQuery(tab_content_id).removeClass('a_hide').addClass('a_active');
        }
      });
    }
  }
};

AegisUI = {
  alert: function(message) {
    jQuery.amaran({
      message: message,
      position: 'bottom right',
      inEffect: 'slideRight'
    });
  },
  initColorPicker: function() {
    var color_pickers;
    color_pickers = jQuery('input.a_ui_color');
    if (color_pickers.length) {
      color_pickers.wpColorPicker();
    }
  },
  initMediaCenter: function() {
    jQuery('.a_ui_image').on('click', '.a_image_add', function(event) {
      event.preventDefault();
      a_button_upload = jQuery(this);
      if (a_media) {
        a_media.open();
        return;
      }
      a_media = wp.media.frames.a_media = wp.media({
        title: aegis_json.i18n.media_center,
        button: {
          text: aegis_json.i18n.use
        },
        library: {
          type: 'image'
        },
        multiple: false
      });
      a_media.on('select', function() {
        var attachment;
        attachment = a_media.state().get('selection').first().toJSON();
        a_button_upload.parents('.a_ui_image').find('.a_image_url').val(attachment.url);
      });
      a_media.open();
    });
    jQuery('.a_ui_image').on('click', '.a_image_remove', function(event) {
      event.preventDefault();
      jQuery(this).parents('.a_ui_image').find('.a_image_url').val('');
    });
  }
};

AegisAjax = {
  saveAll: function() {
    var data, rows;
    data = {
      rows: []
    };
    rows = jQuery('.a_grid_item');
    if (rows.length) {
      rows.each(function(r_index, r_element) {
        var cols, current_row, row_data;
        current_row = jQuery(r_element);
        row_data = {
          id: current_row.attr('id'),
          index: current_row.attr('data-index'),
          cols: []
        };
        cols = current_row.find('.a_column_item_outer');
        if (cols.length) {
          cols.each(function(c_index, c_element) {
            var col_data, current_col, widgets;
            current_col = jQuery(c_element);
            col_data = {
              id: current_col.attr('id'),
              index: current_col.attr('data-index'),
              widgets: []
            };
            widgets = current_col.find('.a_block');
            if (widgets.length) {
              widgets.each(function(w_index, w_element) {
                var current_widget, widget_data;
                current_widget = jQuery(w_element);
                widget_data = {
                  id: current_widget.attr('id'),
                  name: jQuery.trim(current_widget.find('.a_body').html())
                };
                col_data.widgets.push(widget_data);
              });
            }
            row_data.cols.push(col_data);
          });
        }
        data.rows.push(row_data);
      });
    }
    jQuery.ajax({
      url: aegis_json.ajax,
      dataType: "html",
      type: 'POST',
      async: true,
      data: {
        data: data,
        action: 'aegis_save_all',
        security: jQuery('#aegis_save_all_security').val(),
        post_id: parseInt(jQuery('#post_ID').val())
      },
      success: function(responseText, textStatus, jqXHR) {
        return AegisUI.alert(responseText);
      }
    });
  },
  getRowCustomizeForm: function(row_id) {
    if (a_current_row) {
      jQuery.ajax({
        url: aegis_json.ajax,
        dataType: "html",
        type: 'POST',
        async: true,
        data: {
          action: 'aegis_get_row_customize_form',
          security: jQuery('#aegis_get_row_customize_form_security').val(),
          post_id: parseInt(jQuery('#post_ID').val()),
          row_id: row_id
        },
        success: function(data, textStatus, jqXHR) {
          jQuery('#a_modal_row_customize .a_row_customize_form').html(data);
          jQuery('#a_modal_row_customize input[name=a_row_id]').val(row_id);
          jQuery('#a_modal_row_customize').dialog('open');
        }
      });
    }
  },
  saveRowCustomize: function(event, form) {
    event.preventDefault();
    form.ajaxSubmit({
      success: function(responseText, statusText, xhr, $form) {
        if (responseText) {
          AegisUI.alert(responseText);
        }
      }
    });
  },
  getColCustomizeForm: function(col_id) {
    if (a_current_col) {
      jQuery.ajax({
        url: aegis_json.ajax,
        dataType: "html",
        type: 'POST',
        async: true,
        data: {
          action: 'aegis_get_col_customize_form',
          security: jQuery('#aegis_get_col_customize_form_security').val(),
          post_id: parseInt(jQuery('#post_ID').val()),
          col_id: col_id
        },
        success: function(data, textStatus, jqXHR) {
          jQuery('#a_modal_col_customize .a_col_customize_form').html(data);
          jQuery('#a_modal_col_customize input[name=a_col_id]').val(col_id);
          jQuery('#a_modal_col_customize').dialog('open');
        }
      });
    }
  },
  saveColCustomize: function(event, form) {
    event.preventDefault();
    form.ajaxSubmit({
      success: function(responseText, statusText, xhr, $form) {
        if (responseText) {
          AegisUI.alert(responseText);
        }
      }
    });
  },
  getWidgetForm: function(widget_id, widget_title, widget_class_name) {
    if (a_current_sidebar) {
      jQuery.ajax({
        url: aegis_json.ajax,
        dataType: "html",
        type: 'POST',
        async: true,
        data: {
          widget_class_name: widget_class_name,
          widget_title: widget_title,
          widget_id: widget_id,
          action: 'aegis_get_widget_form',
          security: jQuery('#aegis_get_widget_form_security').val(),
          post_id: parseInt(jQuery('#post_ID').val())
        },
        success: function(data, textStatus, jqXHR) {
          jQuery('#a_modal_single_widget .a_widget_form').html(data);
          jQuery('#a_modal_single_widget input[name=a_widget_class_name]').val(widget_class_name);
          jQuery('#a_modal_single_widget input[name=a_widget_title]').val(widget_title);
          jQuery('#a_modal_single_widget input[name=a_widget_id]').val(widget_id);
          jQuery('#a_modal_single_widget').dialog('option', 'title', widget_title);
          jQuery('#a_modal_single_widget').dialog('open');
        }
      });
    }
  },
  saveWidget: function(event, form) {
    event.preventDefault();
    form.ajaxSubmit({
      success: function(responseText, statusText, xhr, $form) {
        if (responseText) {
          a_current_sidebar.append(responseText);
          Aegis.initSortableWidget();
          Aegis.initSortableColumn();
          Aegis.initSortableRow();
        }
        AegisAjax.saveAll();
      }
    });
  },
  removeWidget: function(button_remove) {
    var widget;
    widget = button_remove.parents('.a_block');
    jQuery.ajax({
      url: aegis_json.ajax,
      dataType: "html",
      type: 'POST',
      async: true,
      data: {
        widget_id: widget.attr('id'),
        action: 'aegis_remove_widget',
        security: jQuery('#aegis_remove_widget_security').val(),
        post_id: parseInt(jQuery('#post_ID').val())
      },
      success: function(data, textStatus, jqXHR) {
        widget.remove();
        AegisAjax.saveAll();
      }
    });
  }
};
