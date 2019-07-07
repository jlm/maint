$ ->
  modal_holder_selector = '#modal-holder'
  modal_selector = '.modal'

  $(document).on 'click', 'a[data-modal]', ->
    location = $(this).attr('href')
    #Load modal dialog from server
    $.get location, (data)->
      $(modal_holder_selector).html(data).find(modal_selector).modal()
    false

  $(document).on 'ajax:success', 'form[data-modal]', (event, data, _status, xhr)->
      url = xhr.getResponseHeader('Location')
      if url
        # Redirect to url
        window.location = url
      else
        $('#error_explanation').hide()
        # Remove old modal backdrop
        $('.modal-backdrop').remove()
        # Update modal content
        modal = $(data).find('body').html()
        $(modal_holder_selector).html(modal).find(modal_selector).modal()

  # This stuff doesn't seem to work.
  $(document).on 'ajax:error', 'form[data-modal]', (event, data, _status, xhr)->
    url = xhr.getResponseHeader('Location')
    if url
      # Redirect to url
      window.location = url
    else
      errors = jQuery.parseJSON(xhr.responseText)
      errorcount = errors.length
      $('error_explanation').empty()
      if errorcount > 1
        $('#error_explanation').append('<div class="alert alert-error">The form contains ' + errorcount + ' errors.</div>')
      else
        $('#error_explanation').append('<div class="alert alert-error">The form contains 1 error</div>')
        $('#error_explanation').append('<ul>')
        for e in errors
          $('#error_explanation').append('<li>' + e + '</li>')
        $('#error_explanation').append('</ul>')
        $('#error_explanation').show()
      # Update modal content
      modal = $(data).find('body').html()
      $(modal_holder_selector).html(modal).find(modal_selector).modal()

    false
