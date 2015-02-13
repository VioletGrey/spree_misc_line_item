Deface::Override.new(
  virtual_path: 'spree/admin/orders/_form',
  name: 'add_misc_line_items_to_orders_edit',
  insert_top: "[data-hook='admin_order_form_fields']",
  original: '423434f37ded1175488023881a29bcc050019655',
  text: '
  <% if order.line_items.any? %>
    <fieldset class="no-border-bottom">
      <legend align="center">
        Line Items
      </legend>
    </fieldset>
    <table class="index">
      <colgroup>
      <col style="width: 40%;">
      <col style="width: 20%;">
      <col style="width: 20%;">
      <col style="width: 20%;">
    </colgroup>
    <thead>
      <tr><th>Item Description</th>
        <th>Price</th>
        <th>Quantity</th>
        <th>Total</th>
      </tr></thead>
      <tbody>
        <% order.line_items.each do |item| %>
          <tr>
            <td class="item-name">
              <%= item.variant.product.name %><br><%= "(" + variant_options(item.variant) + ")" unless item.variant.option_values.empty? %><br>
            </td>
            <td class="item-price align-center"><%= item.single_display_amount.to_html %></td>
            <td class="item-qty-show align-center">
              <%= item.quantity %>
            </td>
            <td class="item-total align-center"><%= item.display_amount.to_html %></td>
          </tr>
        <% end %>
      </tbody>
    </table>
  <% end %>
  <% if order.misc_line_items.eligible.any? %>
    <fieldset class="no-border-bottom">
      <legend align="center">
        Misc Line Items
      </legend>
    </fieldset>
    <table class="index">
      <colgroup>
      <col style="width: 40%;">
      <col style="width: 20%;">
      <col style="width: 20%;">
      <col style="width: 20%;">
    </colgroup>
    <thead>
      <tr><th>Misc Item Description</th>
        <th>Price</th>
        <th>Quantity</th>
        <th>Total</th>
      </tr></thead>
      <tbody>
        <% order.misc_line_items.each do |item| %>
          <tr>
            <td class="item-name">
              <% if item.has_variant? %>
                <%= item.lineitemeable.product.name %><br><%= "(" + variant_options(item.lineitemeable) + ")" unless item.lineitemeable.option_values.empty? %><br>
              <% else %>
                <%= item.name %>
              <% end %>
            </td>
            <td class="item-price align-center"><%= item.single_display_amount.to_html %></td>
            <td class="item-qty-show align-center">
              <%= item.quantity %>
            </td>
            <td class="item-total align-center"><%= item.display_amount.to_html %></td>
          </tr>
        <% end %>
      </tbody>
    </table>
  <% end %>
  '
)
