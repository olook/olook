# List of Channels available to use on mediator subscribe (or publish)

<table>
<tr>
  <th> channel </th>
  <th> description </th>
  <th> arguments </th>
  <th> modules that fire </th>
</tr>
<tr>
  <td> window:onscroll </td>
  <td> when user scroll window </td>
  <td> none </td>
  <td> application_core/scroll_events </td>
</tr>
<tr>
  <td> cart::update </td>
  <td> when a cart changes (normally involves backend) </td>
  <td>
    json with keys: total[currency str], subtotal[currency str], couponCode[str], usingCoupon[boolean], couponDiscountValue[currency str], totalItens[int]
  </td>
  <td> app/views/cart/cart/update.js/erb and app/views/cart/items/_update_rows.js.erb </td>
</tr>
</table>
