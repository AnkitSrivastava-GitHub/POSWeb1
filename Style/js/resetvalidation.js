function Resetvalidation() {
    var validators = window.Page_Validators;
    for (var i = 0; i < validators.length; i++) {
        validators[i].IsValid = true;
        window.ValidatorUpdateDisplay(validators[i]);
        //Clear out all the callouts and hide them
        try {
            var callOutId = validators[i].ValidatorCalloutBehavior._id;
            var callOut = window.$find(callOutId);
            if (callOut)
                callOut.hide();
        }
        catch (e) { }
        // I can't remember why I repeated this code, not sure if necessary
        validators[i].IsValid = true;
        window.ValidatorUpdateDisplay(validators[i]);
    }
    // hide the summary
    if (typeof (window.Page_ValidationSummaries) != "undefined") { //hide the validation summaries  
        for (var sums = 0; sums < window.Page_ValidationSummaries.length; sums++) {
            var summary = window.Page_ValidationSummaries[sums];
            summary.style.display = "none";
        }
    }
    $("input[type='text']").removeClass("border");
    $("textarea").removeClass("border");
    $("select").removeClass("border");
};

function ChangeValue(control) {
    control.value = control.value == "0.00" ? "" : control.value;
   

}
function SetValue(control) {  
    control.value = control.value == "" ? "0.00" : control.value;
  
}
function ChangeValueQty(control) {
    control.value = control.value == "0" ? "" : control.value;

}
function SetValueQty(control) {
    control.value = control.value == "" ? "0" : control.value;

}

function numaric(a) {
  
    if (a.value != a.value.replace(/[^0-9\.]/g, '')) {
        a.value = a.value.replace(/[^0-9\.]/g, '');
    }
};
$(function () {
    var cnt = 10; //$("#custom_notifications ul.notifications li").length + 1;
    TabbedNotification = function (options) {
        var message = "<div id='ntf" + cnt + "' class='text alert-" + options.type + "' style='display:none'><h2><i class='fa fa-bell'></i> " + options.title + "</h2><div class='close'><a href='javascript:;' class='notification_close'><i class='fa fa-close'></i></a></div><p>" + options.text + "</p></div>";

        if (document.getElementById('custom_notifications') == null) {
            alert('doesnt exists');
        } else {
            $('#custom_notifications ul.notifications').append("<li><a id='ntlink" + cnt + "' class='alert-" + options.type + "' href='#ntf" + cnt + "'><i class='fa fa-bell animated shake'></i></a></li>");
            $('#custom_notifications #notif-group').append(message);
            cnt++;
            CustomTabs(options);
        }
    }

    CustomTabs = function (options) {
        $('.tabbed_notifications > div').hide();
        $('.tabbed_notifications > div:first-of-type').show();
        $('#custom_notifications').removeClass('dsp_none');
        $('.notifications a').click(function (e) {
            e.preventDefault();
            var $this = $(this),
                        tabbed_notifications = '#' + $this.parents('.notifications').data('tabbed_notifications'),
                        others = $this.closest('li').siblings().children('a'),
                        target = $this.attr('href');
            others.removeClass('active');
            $this.addClass('active');
            $(tabbed_notifications).children('div').hide();
            $(target).show();
        });
    }

    CustomTabs();

    var tabid = idname = '';
    $(document).on('click', '.notification_close', function (e) {
        idname = $(this).parent().parent().attr("id");
        tabid = idname.substr(-2);
        $('#ntf' + tabid).remove();
        $('#ntlink' + tabid).parent().remove();
        $('.notifications a').first().addClass('active');
        $('#notif-group div').first().css('display', 'block');
    });
})

   

