! Copyright (C) 2011
! Free Software Foundation, Inc.

! This file is part of the gtk-fortran GTK+ Fortran Interface library.

! This is free software; you can redistribute it and/or modify
! it under the terms of the GNU General Public License as published by
! the Free Software Foundation; either version 3, or (at your option)
! any later version.

! This software is distributed in the hope that it will be useful,
! but WITHOUT ANY WARRANTY; without even the implied warranty of
! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
! GNU General Public License for more details.

! Under Section 7 of GPL version 3, you are granted additional
! permissions described in the GCC Runtime Library Exception, version
! 3.1, as published by the Free Software Foundation.

! You should have received a copy of the GNU General Public License along with
! this program; see the files COPYING3 and COPYING.RUNTIME respectively.
! If not, see <http://www.gnu.org/licenses/>.
!
! Contributed by James Tappin
! Last modification: 03-30-2011

module gtk_hl
  ! A bunch of procedures to implement higher level creators for
  ! the gtk-fortran widgets. Some settings and operations are also
  ! provided for the more intricate widgets.
  !
  ! To date this is very incomplete.
  !
  ! Many ideas in this module were taken from the pilib gtk<->fortran
  ! interface.

  ! Currently included:
  ! hl_gtk_window_new: A top-level window.
  ! hl_gtk_button_new: A simple button
  ! hl_gtk_check_button_new: A check button
  ! hl_gtk_radio_button_new: A radio button with group.
  !     hl_gtk_radio_group_get_select: Which member of a radio group
  !     	is selected.
  !     hl_gtk_radio_group_set_select: Select a member of a radio group.
  ! hl_gtk_entry_new: A 1-line text box
  ! hl_gtk_list1_new: A single column list with indexing
  !     hl_gtk_list1_get_selections: Get the selected row(s) from a list.
  !     hl_gtk_list1_ins: Insert a row into a list
  !     hl_gtk_list1_rem: Delete a row from a list, or clear the list.
  ! hl_gtk_menu_new: Create a menubar.
  ! hl_gtk_menu_submenu: Add a submenu to a menu
  ! hl_gtk_menu_item: Add a button to a menu
  ! hl_gtk_progress_bar_new: A progress bar.
  ! hl_gtk_progress_bar_set: Set the value of a progress bar.
  ! hl_gtk_message_dialog_show

  ! To facilitate the automatic extraction of API information, there are
  ! 2 types of comment block that are extracted:
  !
  ! Blocks delimited by !* and !/ which provide a section header and
  ! an optional description for a group of widgets.
  !
  ! Block delimited by !+ and !- describe an individual routine.
  ! !+ should immediately precede the function or subroutine statement.
  ! The descriptive comments should come between that and the start of
  ! the declarations. The arguments are described in a colon-separated list
  ! with name: type : status : description.
  ! If there is any description following the table, then a line with just
  ! a ! character must terminate the table.

  ! The iso_c_binding & gtk modules are implicitly included in the
  ! gtk_sup -- speeds compilation to omit them here.
  ! use iso_c_binding
  ! use gtk
  use gtk_sup

  use gtk, only: gtk_box_pack_start, gtk_button_new,&
       & gtk_button_new_with_label, gtk_cell_renderer_set_alignment, gtk_cell_renderer&
       &_set_padding, gtk_cell_renderer_set_visible, gtk_cell_renderer_text_new, gtk_c&
       &heck_button_new, gtk_check_button_new_with_label, gtk_container_add, gtk_conta&
       &iner_set_border_width, gtk_dialog_add_button, gtk_dialog_get_content_area, gtk&
       &_dialog_new, gtk_dialog_run, gtk_editable_set_editable, gtk_entry_new, gtk_ent&
       &ry_set_activates_default, gtk_entry_set_max_length, gtk_entry_set_text, gtk_hb&
       &ox_new, gtk_label_new, gtk_list_store_append, gtk_list_store_clear, gtk_list_s&
       &tore_insert, gtk_list_store_newv, gtk_list_store_remove, gtk_list_store_set_va&
       &lue, gtk_menu_bar_new, gtk_menu_bar_set_pack_direction, gtk_menu_item_new, gtk&
       &_menu_item_new_with_label, gtk_menu_item_set_submenu, gtk_menu_new, gtk_menu_s&
       &hell_append, gtk_menu_shell_insert, gtk_orientable_set_orientation, gtk_progre&
       &ss_bar_new, gtk_progress_bar_pulse, gtk_progress_bar_set_fraction, &
       & gtk_progress_bar_set_pulse_step, gtk_progress_bar_set_t&
       &ext, gtk_radio_button_get_group, gtk_radio_button_new, gtk_radio_button_new_wi&
       &th_label, gtk_scrolled_window_new, gtk_scrolled_window_set_policy, gtk_separat&
       &or_menu_item_new, gtk_toggle_button_get_active, gtk_toggle_button_set_active, &
       &gtk_tree_model_get_iter, gtk_tree_model_get_value, gtk_tree_model_iter_n_child&
       &ren, gtk_tree_model_iter_next, gtk_tree_model_iter_nth_child, gtk_tree_path_fr&
       &ee, gtk_tree_selection_get_selected, gtk_tree_selection_get_selected_rows, gtk&
       &_tree_selection_set_mode, gtk_tree_view_append_column, gtk_tree_view_column_ad&
       &d_attribute, gtk_tree_view_column_new, gtk_tree_view_column_pack_start, gtk_tr&
       &ee_view_column_set_fixed_width, gtk_tree_view_column_set_max_width, gtk_tree_v&
       &iew_column_set_reorderable, gtk_tree_view_column_set_resizable, gtk_tree_view_&
       &column_set_sizing, gtk_tree_view_column_set_title, gtk_tree_view_get_model, gt&
       &k_tree_view_get_selection, gtk_tree_view_new, gtk_tree_view_new_with_model, gt&
       &k_vbox_new, gtk_widget_destroy, gtk_widget_set_sensitive, gtk_widget_set_size_&
       &request, gtk_widget_set_tooltip_text, gtk_widget_show, gtk_widget_show_all, gt&
       &k_window_new, gtk_window_set_default, gtk_window_set_default_size, gtk_window_&
       &set_modal, gtk_window_set_title, g_signal_connect, TRUE, FALSE, &
       & GTK_WINDOW_TOPLEVEL, GTK_POLICY_AUTOMATIC, GTK_TREE_VIEW_COLUMN_FIXED, &
       & GTK_SELECTION_MULTIPLE, GTK_PACK_DIRECTION_LTR, GTK_BUTTONS_NONE, &
       & GTK_BUTTONS_OK, GTK_BUTTONS_CLOSE, GTK_BUTTONS_CANCEL, GTK_BUTTONS_YES_NO, &
       & GTK_BUTTONS_OK_CANCEL, GTK_RESPONSE_OK, GTK_RESPONSE_CLOSE, GTK_RESPONSE_CANCEL, &
       & GTK_RESPONSE_YES, GTK_RESPONSE_NO, GTK_RESPONSE_NONE, &
!       & gtk_progress_bar_set_orientation, gtk_box_pack_start_defaults, &
!       &GTK_PROGRESS_LEFT_TO_RIGHT, GTK_PROGRESS_BOTTOM_TO_TOP, &
!       & GTK_PROGRESS_TOP_TO_BOTTOM, GTK_PROGRESS_RIGHT_TO_LEFT
! Replace the last 2 lines with the next one for GTK3
       & GTK_ORIENTATION_VERTICAL, GTK_ORIENTATION_HORIZONTAL, gtk_progress_bar_set_inverted

  use g, only: alloca, g_list_foreach, g_list_free, g_list_length, g_list_nth, g_&
       &list_nth_data, g_slist_length, g_slist_nth, g_slist_nth_data, g_value_get_int,&
       & g_value_init, g_value_set_int, g_value_set_static_string

  use iso_c_binding

  implicit none

  ! A progress bar value can be given as a fraction or m of n
  interface hl_gtk_progress_bar_set
     module procedure  hl_gtk_progress_bar_set_f
     module procedure  hl_gtk_progress_bar_set_ii
  end interface hl_gtk_progress_bar_set

contains

  !*
  ! Window
  !/
  !+
  function hl_gtk_window_new(title, destroy, delete_event, data_destroy, &
       & data_delete_event, border, wsize, sensitive) result(win)
    ! Higher-level interface to make a gtk_window
    !
    ! TITLE: String: optional: Title for the window
    ! DESTROY: c_funptr: optional: Callback for the "destroy" signal
    ! DELETE_EVENT: c_funptr: optional: Callback for the "delete-event" signal
    ! DATA_DESTROY: c_ptr: optional: Data to be passed to the destroy
    ! 		signal handler
    ! DATA_DELETE_EVENT: c_ptr: optional: Data to be passed to the
    ! 		delete_event signal handler
    ! BORDER: integer: optional: Size of the window border
    ! WSIZE: integer(2): optional: Size of the window
    ! SENSITIVE: boolean: optional: Whether the widget should initially
    ! 		be sensitive or not.
    !-

    type(c_ptr) :: win
    character(kind=c_char), dimension(*), intent(in), optional :: title
    type(c_funptr), optional :: destroy, delete_event
    type(c_ptr), optional :: data_destroy, data_delete_event
    integer, optional, intent(in) :: border
    integer, optional, intent(in), dimension(2) :: wsize
    integer(kind=c_int), intent(in), optional :: sensitive

    win = gtk_window_new (GTK_WINDOW_TOPLEVEL)
    call gtk_window_set_title(win, title)

    if (present(border)) call gtk_container_set_border_width(win, border)
    if (present(wsize)) &
         & call gtk_window_set_default_size(win, wsize(1), wsize(2))

    if (present(delete_event)) then
       if (present(data_delete_event)) then
          call g_signal_connect(win, "delete-event"//CNULL, delete_event, &
               & data_delete_event)
       else
          call g_signal_connect(win, "delete-event"//CNULL, delete_event)
       end if
    end if

    if (present(destroy)) then
       if (present(data_destroy)) then
          call g_signal_connect(win, "destroy"//CNULL, destroy, &
               & data_destroy)
       else
          call g_signal_connect(win, "destroy"//CNULL, destroy)
       end if
    end if

    if (present(sensitive)) &
         & call gtk_widget_set_sensitive(win, sensitive)

  end function hl_gtk_window_new

  !*
  ! Buttons
  !/
  !+
  function hl_gtk_button_new(label, clicked, data, tooltip, sensitive) &
       & result(but)
    ! Higher-level button
    !
    ! LABEL: string: required: The label on the button
    ! CLICKED: c_funptr: optional: callback routine for the "clicked" signal
    ! DATA: c_ptr: optional: Data to be passed to the clicked callback
    ! TOOLTIP: string: optional: tooltip to be displayed when the pointer
    ! 		is held over the button.
    ! SENSITIVE: boolean: optional: Whether the widget should initially
    ! 		be sensitive or not.
    !-

    type(c_ptr) :: but
    character(kind=c_char), dimension(*), intent(in) :: label
    type(c_funptr), optional :: clicked
    type(c_ptr), optional :: data
    character(kind=c_char), dimension(*), intent(in), optional :: tooltip
    integer(kind=c_int), intent(in), optional :: sensitive

    but=gtk_button_new_with_label(label)

    if (present(clicked)) then
       if (present(data)) then
          call g_signal_connect(but, "clicked"//CNULL, &
               & clicked, data)
       else
          call g_signal_connect(but, "clicked"//CNULL, &
               & clicked)
       end if
    end if

    if (present(tooltip)) call gtk_widget_set_tooltip_text(but, tooltip)
    if (present(sensitive)) &
         & call gtk_widget_set_sensitive(but, sensitive)

  end function hl_gtk_button_new

  !+
  function hl_gtk_check_button_new(label, toggled, data, tooltip, &
       & initial_state, sensitive) result(but)
    ! Higher level check box.
    !
    ! LABEL: string: required:  The label on the button.
    ! TOGGLED: c_funptr: optional: Callback function for the "toggled" signal.
    ! DATA: c_ptr: optional: Data to pass to/from the toggled callback.
    ! TOOLTIP: string: optional: A tooltip for the check_button.
    ! INITIAL_STATE: integer: optional: set the initial state of the
    !               check_button.
    ! SENSITIVE: boolean: optional: Whether the widget should initially
    ! 		be sensitive or not.
    !-

    type(c_ptr) :: but
    character(kind=c_char), dimension(*), intent(in) :: label
    type(c_funptr), optional :: toggled
    type(c_ptr), optional :: data
    character(kind=c_char), dimension(*), intent(in), optional :: tooltip
    integer(kind=c_int), intent(in), optional :: initial_state
    integer(kind=c_int), intent(in), optional :: sensitive

    but = gtk_check_button_new_with_label(label)

    if (present(toggled)) then
       if (present(data)) then
          call g_signal_connect(but, "toggled"//cnull, toggled, data)
       else
          call g_signal_connect(but, "toggled"//cnull, toggled)
       end if
    end if

    if (present(tooltip)) call gtk_widget_set_tooltip_text(but, tooltip)

    if (present(initial_state)) &
         & call gtk_toggle_button_set_active(but, initial_state)

    if (present(sensitive)) &
         & call gtk_widget_set_sensitive(but, sensitive)

  end function hl_gtk_check_button_new

  !+
  function hl_gtk_radio_button_new(group, label, toggled, data, tooltip, &
       & sensitive) result(but)
    ! Radio button
    !
    ! GROUP: c_ptr: required: The group to which the button belongs.
    ! 		This is an INOUT argument so it must be a variable
    ! 		of type(c_ptr). To start a new group (menu) initialize
    ! 		the variable to NULL, to add a new button use the value
    ! 		returned from the last call to hl_gtk_radio_button_new. This
    ! 		is the variable which you use to do things like setting the
    ! 		selection.
    ! LABEL: string: required: The label for the button.
    ! TOGGLED: c_funptr: optional: call back to be executed when the
    ! 		button is toggled
    ! DATA: c_ptr: optional: Data to pass to/from the "toggled" callback.
    ! TOOLTIP: string: optional: A tooltip for the radio button
    ! SENSITIVE: boolean: optional: Whether the widget should initially
    ! 		be sensitive or not.
    !-

    type(c_ptr) :: but
    type(c_ptr), intent(inout) :: group
    character(kind=c_char), dimension(*), intent(in) :: label
    type(c_funptr), optional :: toggled
    type(c_ptr), optional :: data
    character(kind=c_char), dimension(*), intent(in), optional :: tooltip
    integer(kind=c_int), intent(in), optional :: sensitive

    but = gtk_radio_button_new_with_label(group, label)
    group = gtk_radio_button_get_group(but)

    if (present(toggled)) then
       if (present(data)) then
          call g_signal_connect(but, "toggled"//cnull, toggled, data)
       else
          call g_signal_connect(but, "toggled"//cnull, toggled)
       end if
    end if
    if (present(tooltip)) call gtk_widget_set_tooltip_text(but, tooltip)

    if (present(sensitive)) &
         & call gtk_widget_set_sensitive(but, sensitive)

  end function hl_gtk_radio_button_new

  !+
  subroutine hl_gtk_radio_group_set_select(group, index)
    ! Set the indexth button of a radio group
    !
    ! GROUP: c_ptr: required: The group of the last button added to
    ! 		the radio menu
    ! INDEX: integer: required: The index of the button to set
    ! 		(starting from the first as 0).
    !-

    type(c_ptr), intent(in) :: group
    integer(kind=c_int), intent(in) :: index

    integer(kind=c_int) :: nbuts
    type(c_ptr) :: datan

    nbuts = g_slist_length(group)

    ! Note that GROUP actually points to the last button added and to the
    ! group of the next to last & so on

    datan= g_slist_nth_data(group, nbuts-index-1)
    call gtk_toggle_button_set_active(datan, TRUE)

  end subroutine hl_gtk_radio_group_set_select

  !+
  function hl_gtk_radio_group_get_select(group) result(index)
    ! Find the selected button in a radio group.
    !
    ! GROUP: c_ptr: required: The group of the last button added to
    ! 		the radio menu
    !-

    integer(kind=c_int) :: index
    type(c_ptr), intent(in) :: group

    integer(kind=c_int) :: nbuts, i
    type(c_ptr) :: but

    nbuts = g_slist_length(group)
    index=-1

    do i = 1, nbuts
       but = g_slist_nth_data(group, nbuts-i)
       if (.not. c_associated(but)) exit

       if (gtk_toggle_button_get_active(but)==TRUE) then
          index = i-1
          return
       end if
    end do
  end function hl_gtk_radio_group_get_select

  !*
  ! Text Entry
  !/

  !+
  function hl_gtk_entry_new(len, editable, activate, data, tooltip, value, &
       & sensitive) result(entry)
    ! Higher level text entry box
    !
    ! LEN: integer: optional: The maximum length of the entry field.
    ! EDITABLE: boolean: optional: whether the entry box can be edited
    ! 		by the user
    ! ACTIVATE: c_funptr: optional: Callback function for the "activate" signal
    ! DATA: c_ptr: optional: Data to be passed to the activate callback
    ! TOOLTIP: string: optional: tooltip to be displayed when the pointer
    ! 		is held over the button.
    ! VALUE: string: optional: An initial value for the entry box.
    ! SENSITIVE: boolean: optional: Whether the widget should initially
    ! 		be sensitive or not.
    !-

    type(c_ptr) :: entry
    integer, intent(in), optional :: len
    integer(c_int), intent(in), optional :: editable
    type(c_funptr), optional :: activate
    type(c_ptr), optional :: data
    character(kind=c_char), dimension(*), intent(in), optional :: tooltip, value
    integer(kind=c_int), intent(in), optional :: sensitive

    entry = gtk_entry_new()
    call gtk_entry_set_activates_default(entry, TRUE)

    if (present(len)) call gtk_entry_set_max_length(entry, len)

    if (present(editable)) &
         & call gtk_editable_set_editable(entry, editable)

    if (present(activate)) then
       if (present(data)) then
          call g_signal_connect(entry, &
               & "activate"//CNULL, activate, data)
       else
          call g_signal_connect(entry, &
               & "activate"//CNULL, activate)
       end if
    end if

    if (present(tooltip)) call gtk_widget_set_tooltip_text(entry, tooltip)

    if (present(value)) call gtk_entry_set_text(entry, value)
    if (present(sensitive)) &
         & call gtk_widget_set_sensitive(entry, sensitive)

  end function hl_gtk_entry_new

  !*
  ! List1
  ! This is a single column list based on the GtkTreeView widget system.
  !/
  !+
  function hl_gtk_list1_new(scroll, width, changed, data, multiple, &
       & sensitive, tooltip, title, height) result(list)
    ! A single column selectable list based on the GTK Tree View
    !
    ! SCROLL: c_ptr: required: The scroll box containing the list
    ! 		(used for packing etc.)
    ! WIDTH: integer: optional: The width of the displayed column.
    ! CHANGED: c_funptr: optional: Callback function for the "changed"
    !           signal to the associated selection object.
    ! DATA: c_ptr: optional: Data to be passed to/from the callback.
    ! MULTIPLE: boolean: optional: Whether multiple selections are allowed.
    ! SENSITIVE: boolean: optional: Whether the widget is intially sensitive.
    ! TOOLTIP: string: optional: Tooltip for the widget
    ! TITLE: string: optional: Title for the visible column.
    ! HEIGHT: integer: optional: The height of the display (this is
    !            actually the height of the scroll box).
    !-

    type(c_ptr) :: list
    type(c_ptr), intent(out) :: scroll
    integer(kind=c_int), intent(in), optional :: width
    type(c_funptr), intent(in), optional :: changed
    type(c_ptr), intent(in), optional :: data
    integer(kind=c_int), intent(in),  optional :: multiple, sensitive
    character(kind=c_char), dimension(*), intent(in), optional :: tooltip, title
    integer(kind=c_int), intent(in), optional :: height

    type(c_ptr), target :: renderer, column, select, model
    integer(kind=c_int) :: nc
    integer(kind=type_kind), target, dimension(2) :: types

    ! Create list storage with 2 colums (one is a dummy, to provide an index)

    types = (/ g_type_int, g_type_string /)
    model = gtk_list_store_newv(2, c_loc(types))

    ! Create visual list inside a scrollbar container
    scroll = gtk_scrolled_window_new(NULL, NULL)
    call gtk_scrolled_window_set_policy(scroll, GTK_POLICY_AUTOMATIC, &
         & GTK_POLICY_AUTOMATIC)
    list = gtk_tree_view_new_with_model(model)
    call gtk_container_add(scroll, list)

    ! Insert index column (invisible)
    renderer = gtk_cell_renderer_text_new()
    call gtk_cell_renderer_set_visible(renderer, FALSE)
    column = gtk_tree_view_column_new()
    call gtk_tree_view_column_pack_start(column, renderer, FALSE)
    call gtk_tree_view_column_set_title(column, "#"//cnull)
    call gtk_tree_view_column_add_attribute(column, renderer, &
         & "text"//CNULL, 0)
    nc = gtk_tree_view_append_column(list, column)
    call gtk_tree_view_column_set_sizing (column,GTK_TREE_VIEW_COLUMN_FIXED)
    call gtk_tree_view_column_set_max_width(column,0)

    ! Insert (visible) column

    renderer = gtk_cell_renderer_text_new()
    column = gtk_tree_view_column_new()
    call gtk_tree_view_column_pack_start(column, renderer, FALSE)
    call gtk_cell_renderer_set_alignment(renderer, 0., 0.)
    call gtk_cell_renderer_set_padding(renderer, 0, 0)
    if (present(title)) call gtk_tree_view_column_set_title(column, title)
    call gtk_tree_view_column_add_attribute(column, renderer, &
         & "text"//CNULL, 1)
    nc = gtk_tree_view_append_column(list, column)

    call gtk_tree_view_column_set_reorderable(column, FALSE)

    ! Set sizes if requested. Note that the vertical size is set with the
    ! scrollable window.
    if (present(width)) then
       call gtk_tree_view_column_set_sizing (column, GTK_TREE_VIEW_COLUMN_FIXED)
       call gtk_tree_view_column_set_fixed_width(column, width)
    end if
    if (present(height)) call gtk_widget_set_size_request(scroll,0,height)

    call gtk_tree_view_column_set_resizable(column,TRUE)

    ! The event handler is attached to the selection object, as is
    ! the multiple selection property.

    select = gtk_tree_view_get_selection(list)

    if (present(multiple)) then
       if (multiple == TRUE) &
            & call gtk_tree_selection_set_mode(select, GTK_SELECTION_MULTIPLE)
    end if

    if (present(changed)) then
       if (present(data)) then
          call g_signal_connect(select, "changed"//cnull, changed, data)
       else
          call g_signal_connect(select, "changed"//cnull, changed)
       end if
    end if

    if (present(tooltip)) call gtk_widget_set_tooltip_text(list, tooltip)

    if (present(sensitive)) &
         & call gtk_widget_set_sensitive(list, sensitive)

  end function hl_gtk_list1_new

  !+
  subroutine hl_gtk_list1_ins(list, text, row)
    ! Insert a row into a list
    !
    ! LIST: c_ptr: required: The list to insert to.
    ! TEXT: string: required: The text to insert.
    ! ROW: integer: optional: The row at which to insert the text
    ! 		(omit to append)
    !-

    type(c_ptr), intent(in) :: list
    character(kind=c_char), dimension(*), intent(in), target :: text
    integer(kind=c_int), intent(in), optional :: row

    integer(kind=c_int), target :: i, nrow
    integer(kind=c_int) :: valid

    type(c_ptr) :: store, val
    type(gtktreeiter), target :: iter
    type(gvalue), target :: vali, valt

    ! Get list storage
    store = gtk_tree_view_get_model(list)

    ! Insert row
    if (present(row)) then
       call gtk_list_store_insert(store, c_loc(iter), row)
       nrow = row
    else
       nrow=gtk_tree_model_iter_n_children (store, NULL);
       call gtk_list_store_append(store, c_loc(iter));
    end if

    ! Set value
    val = c_loc(vali)
    val=g_value_init(val, g_type_int)
    call g_value_set_int(c_loc(vali), nrow)
    call gtk_list_store_set_value(store, c_loc(iter), 0, val)
    val = c_loc(valt)
    val=g_value_init(val, g_type_string)
    call g_value_set_static_string(c_loc(valt), text)
    call gtk_list_store_set_value(store, c_loc(iter), 1, val)

    ! reset the indices for the rest of the list
    if (present(row)) then
       i = row
       do
          valid = gtk_tree_model_iter_next(store, c_loc(iter))
          if (valid == FALSE) exit
          i = i+1
          call gtk_list_store_set_value(store, c_loc(iter), 0, c_loc(i))
       end do
    end if
  end subroutine hl_gtk_list1_ins

  !+
  subroutine hl_gtk_list1_rem(list, row)
    ! Remove a row or clear a list
    !
    ! LIST: c_ptr: required: The list to modify
    ! ROW: integer: optional: The row to remove, if absent clear the list
    !-

    type(c_ptr), intent(in) :: list
    integer(kind=c_int), optional, intent(in) :: row

    integer(kind=c_int), target :: i
    integer(kind=c_int) :: valid
    type(c_ptr) :: store, val
    type(gtktreeiter), target :: iter
    type(gvalue), target :: vali

    ! Get list store
    store = gtk_tree_view_get_model(list)

    ! If 2 arguments, then remove a row
    if (present(row)) then
       valid = gtk_tree_model_iter_nth_child(store, c_loc(iter), NULL, row)
       if (valid==FALSE) return

       valid = gtk_list_store_remove(store, c_loc(iter))
       if (valid==TRUE) then   ! Not the last element
          i = row
          val = c_loc(vali)
          val = g_value_init(val, g_type_int)
          do
             call g_value_set_int(val, i)
             call gtk_list_store_set_value(store, c_loc(iter), 0, val)
             valid=gtk_tree_model_iter_next(store, c_loc(iter));
             if (valid==FALSE) exit
             i=i+1
          end do
       end if

    else   ! 1 argument clear the whole list
       call gtk_list_store_clear(store)
    end if
  end subroutine hl_gtk_list1_rem

  !+
  function hl_gtk_list1_get_selections(list, indices, selection) result(count)
    ! Get the indices of the selected rows
    !
    ! LIST: c_ptr: required: The list whose selections are to be found.
    ! INDICES: integer: optional: An allocatable array to return the
    ! 		list of selections. (If count = 0 it will not be allocated).
    ! 		If this argument is not given, then the number of
    ! 		selected rows is returned.
    ! SELECTION: c_ptr: optional: A selection. If this is given then LIST
    !           is ignored. This is most often used in the callback routine
    !           for the changed signal when that needs to find which element(s)
    !           are selected.
    !
    ! Returns the number of selections.
    !-

    integer(kind=c_int) :: count
    type(c_ptr), intent(in) :: list
    integer(kind=c_int), dimension(:), allocatable, target, &
         & intent(out), optional :: indices
    type(c_ptr), optional :: selection

    type(c_ptr) :: slist, vselection
    type(c_ptr), target :: model
    integer(kind=c_int) :: i
    type(c_ptr) :: cindex
    integer(kind=c_int) :: valid
    type(gtktreeiter), target :: iter
    type(gvalue), target :: val

    if (present(selection)) then
       vselection = selection
    else
       vselection = gtk_tree_view_get_selection(list)
    end if

    slist = gtk_tree_selection_get_selected_rows(vselection, &
         & c_loc(model))

    ! If no selections, then set the count to 0 and return
    if (.not. c_associated(slist)) then
       count=0
       return
    end if

    ! Determine how many rows are selected. Then if no output list was
    ! supplied, return, otherwise go on and make a list.
    count = g_list_length(slist)
    if (.not. present(indices)) return

    allocate(indices(count))

    ! For each of the elements in the selection list, find its index
    ! from the hidden first column
    do i = 1, count
       valid = gtk_tree_model_get_iter(model, c_loc(iter), &
            & g_list_nth_data(slist, i-1))
       call gtk_tree_model_get_value(model, c_loc(iter), 0, c_loc(val))
       indices(i) = g_value_get_int(c_loc(val))
       call clear_gvalue(val)
    end do

    ! Free the selection list.
    call g_list_foreach(slist, c_funloc(gtk_tree_path_free), NULL)
    call g_list_free(slist)

  end function hl_gtk_list1_get_selections

  !*
  ! Pulldown Menu
  !/
  !+
  function hl_gtk_menu_new(orientation) result(menu)
    ! Menu initializer (mainly for consistency)
    !
    ! ORIENTATION: integer: optional: Whether to lay out the top level
    ! 		horizontaly or vertically.
    !-

    type(c_ptr) :: menu
    integer(kind=c_int), intent(in), optional :: orientation

    integer(kind=c_int) :: orient
    if (present(orientation)) then
       orient= orientation
    else
       orient = GTK_PACK_DIRECTION_LTR
    end if

    menu = gtk_menu_bar_new()
    call gtk_menu_bar_set_pack_direction (menu, orient)

  end function hl_gtk_menu_new

  !+
  function hl_gtk_menu_submenu_new(menu, label, tooltip, pos) result(submenu)
    ! Make a submenu node
    !
    ! MENU: c_ptr: required:  The parent of the submenu
    ! LABEL: string: required: The label of the submenu
    ! TOOLTIP: string: optional: A tooltip for the submenu.
    ! POS: integer: optional: The position at which to insert the item
    ! 		(omit to append)
    !-

    type(c_ptr) :: submenu
    type(c_ptr) :: menu
    character(kind=c_char), dimension(*), intent(in) :: label
    character(kind=c_char), dimension(*), intent(in), optional :: tooltip
    integer(kind=c_int), optional :: pos

    type(c_ptr) :: item

    ! Create a menu item
    item = gtk_menu_item_new_with_label(label)

    ! Create a submenu and attach it to the item
    submenu = gtk_menu_new()
    call  gtk_menu_item_set_submenu(item, submenu)

    ! Insert it to the parent
    if (present(pos)) then
       call gtk_menu_shell_insert(menu, item, pos)
    else
       call gtk_menu_shell_append(menu, item)
    end if

    if (present(tooltip)) call gtk_widget_set_tooltip_text(item, tooltip)

  end function hl_gtk_menu_submenu_new

  !+
  function hl_gtk_menu_item_new(menu, label, activate, data, tooltip, pos) &
       & result(item)
    ! Make a menu item or separator
    !
    ! MENU: c_ptr: required: The parent menu.
    ! LABEL: string: optional: The label for the menu, if absent then insert
    ! 		a separator.
    ! ACTIVATE: c_funptr: optional: The callback function for the
    ! 		activate signal
    ! DATA: c_ptr: optional: Data to pass to the callback.
    ! TOOLTIP: string: optional: A tooltip for the menu item.
    ! POS: integer: optional: The position at which to insert the item
    ! 		(omit to append)
    !-

    type(c_ptr) ::  item
    type(c_ptr) :: menu
    character(kind=c_char), dimension(*), intent(in), optional :: label
    type(c_funptr), optional :: activate
    type(c_ptr), optional :: data
    character(kind=c_char), dimension(*), intent(in), optional :: tooltip
    integer(kind=c_int), optional :: pos

    ! Create the menu item
    if (present(label)) then
       item = gtk_menu_item_new_with_label(label)
    else
       item = gtk_separator_menu_item_new()
    end if

    ! Insert it to the parent
    if (present(pos)) then
       call gtk_menu_shell_insert(menu, item, pos)
    else
       call gtk_menu_shell_append(menu, item)
    end if

    ! If present, connect the callback
    if (present(activate)) then
       if (.not. present(label)) then
          print *, "HL_GTK_MENU_ITEM: Cannot connect a callback to a separator"
          return
       end if

       if (present(data)) then
          call g_signal_connect(item, "activate"//cnull, activate, data)
       else
          call g_signal_connect(item, "activate"//cnull, activate)
       end if
    end if

    ! Attach a tooltip
    if (present(tooltip)) call gtk_widget_set_tooltip_text(item, tooltip)
  end function hl_gtk_menu_item_new

  !*
  ! Progress Bar
  !/

  !+
  function hl_gtk_progress_bar_new(vertical, reversed, step) result(bar)
    ! Intializer for a progress bar
    !
    ! ORIENTATION: integer: optional: The orientation of the bar.
    ! STEP: double: optional: The fractional step to advance when
    ! 		pulsing the bar
    !-

    type(c_ptr) :: bar
    integer(kind=c_int), optional :: vertical, reversed
    real(kind=c_double), optional :: step

    integer(kind=c_int) :: orientation

    bar = gtk_progress_bar_new()

    ! GTK2 version
!    orientation = GTK_PROGRESS_LEFT_TO_RIGHT
!    if (present(vertical)) then
!       if (vertical == TRUE) orientation = GTK_PROGRESS_BOTTOM_TO_TOP
!       if (present(reversed)) then
!          if (reversed == TRUE) orientation = GTK_PROGRESS_TOP_TO_BOTTOM
!       end if
!    else if (present(reversed)) then
!       if (reversed == TRUE) orientation = GTK_PROGRESS_RIGHT_TO_LEFT
!    end if
!    call gtk_progress_bar_set_orientation(bar, orientation)
    ! end GTK2 version
    ! GTK3 version
    if (present(vertical)) then
       if (vertical == TRUE) then
          call gtk_orientable_set_orientation (bar, &
               & GTK_ORIENTATION_VERTICAL)
       else
          call gtk_orientable_set_orientation (bar, &
               & GTK_ORIENTATION_HORIZONTAL)
       end if
    end if

    if (present(reversed)) call gtk_progress_bar_set_inverted(bar, reversed)
    ! end GTK3 version

    if (present(step)) &
         & call gtk_progress_bar_set_pulse_step(bar, step)

  end function hl_gtk_progress_bar_new

  !+
  subroutine hl_gtk_progress_bar_set_f(bar, val, string, text)
    ! Set the value of a progress bar (fraction or pulse)
    !
    ! BAR: c_ptr: required: The bar to set
    ! VAL: double: optional: The value to set. If absent, the bar is pulsed
    ! STRING: boolean: optional: Whether to put a string on the bar.
    ! TEXT: string: optional: Text to put in the bar, (overrides STRING)
    !
    ! This routine is normally accessed via the generic interface
    ! hl_gtk_progress_bar
    !-

    type(c_ptr) :: bar
    real(kind=c_double), optional :: val
    integer(kind=c_int), optional :: string
    ! character(kind=c_char), dimension(*), intent(in), optional :: text
    character(len=*), intent(in), optional:: text

    real(kind=c_double) :: frac
    character(len=50) :: sval

    ! If no value given pulse the bar
    if (.not. present(val)) then
       call gtk_progress_bar_pulse(bar)
    else
       ! Determine the fraction to fill & fill it
       call gtk_progress_bar_set_fraction(bar, val)
    end if

    ! If annotation is needed, add it.
    if (present(text)) then
       call gtk_progress_bar_set_text (bar, text//cnull)
    else if (present(string)) then
       if (string == FALSE .or. .not. present(val)) return
       ! Otherwise we display a percentage
       write(sval, "(F5.1,'%')") val*100.

       call gtk_progress_bar_set_text (bar, trim(sval)//cnull)
    end if
  end subroutine hl_gtk_progress_bar_set_f

  !+
  subroutine hl_gtk_progress_bar_set_ii(bar, val, maxv, string, text)
    ! Set the value of a progress bar (n of m)
    !
    ! BAR: c_ptr: required: The bar to set
    ! VAL: int: required: The value to set.
    ! MAXV: int: required: The maximum value for the bar
    ! STRING: boolean: optional: Whether to put a string on the bar.
    ! TEXT: string: optional: Text to put in the bar, (overrides STRING)
    !
    ! This routine is normally accessed via the generic interface
    ! hl_gtk_progress_bar
    !-

    type(c_ptr) :: bar
    integer(kind=c_int) :: val, maxv
    integer(kind=c_int), optional :: string
    !    character(kind=c_char), dimension(*), intent(in), optional :: text
    character(len=*), intent(in), optional:: text
    real(kind=c_double) :: frac
    character(len=50) :: sval

    frac = real(val,c_double)/real(maxv,c_double)
    call gtk_progress_bar_set_fraction(bar, frac)

    ! If annotation is needed, add it.
    if (present(text)) then
       call gtk_progress_bar_set_text (bar, text//cnull)
    else if (present(string)) then
       if (string == FALSE) return
       ! Otherwise we display n or m
       write(sval, "(I0,' of ',I0)") val, maxv
       call gtk_progress_bar_set_text (bar, trim(sval)//cnull)
    end if
  end subroutine hl_gtk_progress_bar_set_ii

  !*
  ! Dialogue
  ! The message dialogue provided is here because, the built-in message
  ! dialogue GtkMessageDialog cannot be created without calling variadic
  ! functions which are not compatible with Fortran, therefore this is
  ! based around the plain GtkDialog family. 
  !/

  !+
  function hl_gtk_message_dialog_show(message, button_set, title) &
       & result(resp)
    ! A DIY version of the message dialogue, needed because both creators
    ! for the built in one are variadic and so not callable from Fortran.
    !
    ! MESSAGE: string(n): required: The message to display. Since this is
    ! 		a string array, the CNULL terminations are provided internally
    ! BUTTON_SET: integer: required: The set of buttons to display
    ! TITLE: string: optional: Title for the window.
    !
    ! The return value is the response code, not the widget.
    !-

    integer(kind=c_int) :: resp
    character(len=*), dimension(:), intent(in) :: message
    integer(kind=c_int), intent(in) :: button_set
    character(kind=c_char), dimension(*), intent(in), optional :: title

    type(c_ptr) :: dialog, content, junk
    integer :: i

    ! Create the dialog window and make it modal.

    dialog=gtk_dialog_new()
    call gtk_window_set_modal(dialog, TRUE)
    if (present(title)) call gtk_window_set_title(dialog, title)

    ! Get the content area and put the message in it.
    content = gtk_dialog_get_content_area(dialog)

    do i = 1, size(message)
       junk = gtk_label_new(trim(message(i))//cnull)
       call gtk_box_pack_start(content, junk, TRUE, TRUE, 0)
    end do

    select case (button_set)
    case (GTK_BUTTONS_NONE)
    case (GTK_BUTTONS_OK)
       junk = gtk_dialog_add_button(dialog, GTK_STOCK_OK, GTK_RESPONSE_OK)
    case (GTK_BUTTONS_CLOSE)
       junk = gtk_dialog_add_button(dialog, GTK_STOCK_CLOSE, &
            & GTK_RESPONSE_CLOSE)
    case (GTK_BUTTONS_CANCEL)
       junk = gtk_dialog_add_button(dialog, GTK_STOCK_CANCEL, &
            & GTK_RESPONSE_CANCEL)
    case (GTK_BUTTONS_YES_NO)
       junk = gtk_dialog_add_button(dialog, GTK_STOCK_YES, GTK_RESPONSE_YES)
       junk = gtk_dialog_add_button(dialog, GTK_STOCK_NO, GTK_RESPONSE_NO)
    case (GTK_BUTTONS_OK_CANCEL)
       junk = gtk_dialog_add_button(dialog, GTK_STOCK_OK, GTK_RESPONSE_OK)
       junk = gtk_dialog_add_button(dialog, GTK_STOCK_CANCEL, &
            & GTK_RESPONSE_CANCEL)
    case default
       call gtk_widget_destroy(dialog)
       resp = GTK_RESPONSE_NONE
       return
    end select

    call gtk_widget_show_all (dialog)
    resp = gtk_dialog_run(dialog)
    call gtk_widget_destroy(dialog)

  end function hl_gtk_message_dialog_show

  !*
  ! Box
  ! A simplified way to make vertical or horizontal boxes
  ! This was added because the gtk_box_pack_start_defaults
  ! procedure is removed from GTK3.x
  !/
  !+
  function hl_gtk_box_new(horizontal, homogeneous, spacing) result(box)
    ! Generic packing box
    !
    ! HORIZONTAL: boolean: optional: Set to TRUE to make a row box. FALSE or
    !		absent implies a column box.
    ! HOMOGENEOUS: boolean: optional: If set to TRUE then all children are
    ! 		the same size, FALSE or absent allows each widget to take its
    ! 		natural size.
    ! SPACING: c_int: optional: Set the space between children.
    !-

    type(c_ptr) :: box
    integer(kind=c_int), intent(in), optional :: horizontal, homogeneous
    integer(kind=c_int), intent(in), optional :: spacing

    integer(kind=c_int) :: grid, space

    if (present(homogeneous)) then
       grid = homogeneous
    else
       grid=FALSE
    end if

    if (present(spacing)) then
       space = spacing
    else
       space=0
    end if

    if (present(horizontal)) then
       if (horizontal == TRUE) then
          box = gtk_hbox_new(grid, space)
       else
          box = gtk_vbox_new(grid, space)
       end if
    else
       box = gtk_vbox_new(grid, space)
    end if
  end function hl_gtk_box_new

  !+
  subroutine hl_gtk_box_pack(box, child, expand, fill, padding, atend)
    ! Put a widget into a box
    !
    ! BOX: c_ptr: required: The box into which to put the child
    ! CHILD: c_ptr: required: The child to pack
    ! EXPAND: boolean: optional: If TRUE then expand this child when
    ! 		filling the box, if FALSE don't, (Default TRUE)
    ! FILL: boolean: optional: If TRUE, then expand the widget when
    ! 		expanding, if FALSE, then put space round it. (Default TRUE,
    ! 		ignored if EXPAND==FALSE.
    ! PADDING: c_int: optional: Extra space to put around the child in the
    ! 		fill direction.
    ! ATEND: boolean: optional: If present and TRUE, then put the child at
    ! 		the end of the box rather than the start.
    !-

    type(c_ptr), intent(in) :: box, child
    integer(kind=c_int), intent(in), optional :: expand, fill
    integer(kind=c_int), intent(in), optional :: padding
    integer(kind=c_int), intent(in), optional :: atend

    integer(kind=c_int) :: iexp, ifill, ipad, iend

    if (present(expand)) then
       iexp = expand
    else
       iexp = TRUE
    end if
    if (present(fill)) then
       ifill = fill
    else
       ifill = TRUE
    end if
    if (present(padding)) then
       ipad = padding
    else
       ipad = 0
    end if
    if (present(atend)) then
       iend = atend
    else
       iend = FALSE
    end if

    call gtk_box_pack_start(box, child, iexp, ifill, ipad)
  end subroutine hl_gtk_box_pack
end module gtk_hl