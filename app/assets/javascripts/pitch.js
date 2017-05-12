$(document).ready(function() {
  $('.picth-datepicker').datetimepicker({
    timepicker: false,
    format: 'd-m-Y'
  });
  $('.pitch-timepicker').datetimepicker({
    datepicker: false,
    format:'H:i'
  });
  
  $('.rent-btn').hide();
  $('.view-match-btn').hide();

  $('.check-mini-pitch').on('click', function(){
    $('.rent-btn').hide();
    $('.view-match-btn').hide();
    var start_hour = $('#start_hour').val();
    var end_hour = $('#end_hour').val();
    var date = $('#date').val();
    var mini_pitch_id = $('#mini_pitch_id').val();

    if (!start_hour || !end_hour || !date){
      $('.check-result-text').html('<h3>' + I18n.t("growl.fill_all_field") + '</h3');
    }
    else {
      $.ajax({
        url: '/check_mini_pitches/', 
        data: {start_hour: start_hour, end_hour: end_hour, date: date,
          mini_pitch_id: mini_pitch_id}, 
        success: function(data) {
          $('.check-result-text').html('<h3>' + data.flash + '</h3>');
          if(data.status === 102) {
            $('.rent-btn').show();
          }

          if(data.status === 101) {
            $('.view-match-btn').show();
            $('.view-match-btn').attr('href', '/matches/' + data.id);
          }
        },
        error: function(error) {
          $('.form-check-result').html('<h3>' + error + '</h3');
        }
      });
    }
    return false;
  });

  $('.rent-modal').on('show.bs.modal', function () {
   $('.rent-mini-pitch-start').html($('#start_hour').val());
   $('.rent-mini-pitch-end').html($('#end_hour').val());
   $('.rent-mini-pitch-date').html($('#date').val());
  });

  $('.rent-mini-pitch-btn').on('click', function(){
    var start_hour = $('#start_hour').val();
    var end_hour = $('#end_hour').val();
    var date = $('#date').val();
    var mini_pitch_id = this.dataset.id;
    var phone = '';
    if ($('.rent-phone-' + mini_pitch_id).length) {
      phone = $('.rent-phone-'+mini_pitch_id).val();
      console.log(phone);
      if (!phone) {
        $.growl.danger({title: I18n.t("growl.title.danger"),
          message: I18n.t("growl.number_phone")});
        return;
      }
    }

    rent = {start_hour: start_hour, end_hour: end_hour, date: date,
      mini_pitch_id: mini_pitch_id}

    $.ajax({
      url: '/rents/',
      method: "POST",
      data: {rent: rent, phone: phone},
      success: function(data) {
        $.growl.notice({title: I18n.t("growl.title.notice"),
          message: data['message']});
        window.location.href = '/rents/' + data.id;
      },
      error: function(error) {
        $.growl.error({title: I18n.t("growl.title.error"),
          message: error});
        window.reload();
      }
    });
    return false;
  });

  $('.new-match-btn').on('click', function(){
    var rent_id = $('#rent_id').val();
    var max_quantity = $('#max_quantity').val();
    var quantity = $('#quantity').val();

    if (Number(max_quantity) <= 0 || Number(quantity) > Number(max_quantity)) {
      $.growl.notice({title: I18n.t("growl.title.notice"),
        message: I18n.t("growl.invalid_quantity")});
    }
    else {
      match = {rent_id: rent_id, max_quantity: max_quantity}

      $.ajax({
        url: '/matches/',
        method: "POST",
        data: {match: match, quantity: quantity},
        success: function(data) {
          window.location.href = '/matches/' + data.id;
          $.growl.notice({title: I18n.t("growl.title.notice"),
            message: data['message']});
        },
        error: function(error) {
          $.growl.error({title: I18n.t("growl.title.error"),
            message: error});
          window.reload();
        }
      });
    }
    return false;
  });

  $('.confirm-join-match-btn').on('click', function(){
    var match_id = $('#match_id').val();
    var available = $('#available_quantity').val();
    var quantity = $('#quantity').val();

    if (Number(quantity) <= 0 || Number(quantity) > Number(available)) {
      $.growl.danger({title: I18n.t("growl.title.danger"),
        message: I18n.t("growl.invalid_quantity")});
    }
    else {
    
      match_user = {match_id: match_id, quantity: quantity}

      $.ajax({
        url: '/match_users/',
        method: "POST",
        data: {match_user: match_user},
        error: function(error) {
          $.growl.error({title: I18n.t("growl.title.error"),
            message: error});
          window.reload();
        }
      });
    }
    return false;
  });

  $('.search-mini-pitch').on('click', function(){
    var start_hour = $('#start_hour').val();
    var end_hour = $('#end_hour').val();
    var date = $('#date').val();
    var pitch_type = $('#pitch_type').val();
    var pitch_id = $('#pitch_id').val();

    if (!start_hour || !end_hour || !date){
      $.growl.warning({title: I18n.t("growl.title.warning"),
        message: I18n.t("growl.fill_all_field")});
      return false;
    }
    $.ajax({
      url: '/search_mini_pitches/', 
      data: {start_hour: start_hour, end_hour: end_hour, date: date,
        pitch_type: pitch_type, pitch_id: pitch_id}, 
      success: function(data) {
       
      },
      error: function(error) {
       
      }
    });
    return false;
  });

  $('.rent-history').on('change', function(){
    var start_date = $('.rent-history-start').val();
    var end_date = $('.rent-history-end').val();
    var pitch_id = $('.pitch-id').val();

    $.ajax({
      url: '/dashboard/pitches/' + pitch_id + '/rent_managers',
      data: {start_date: start_date, end_date: end_date, pitch_id: pitch_id}
    });
    return false;
  });

  $('#rent_search').on('keyup', function() {
  
    pitch_id = $('#pitch_id').val();

    $.ajax({
      type: 'GET',
      url : '/dashboard/pitches/' + pitch_id + '/rents/',
      data: {
        pitch_id: pitch_id, rent_search: $(this).val()
      }
    });
  });

});
