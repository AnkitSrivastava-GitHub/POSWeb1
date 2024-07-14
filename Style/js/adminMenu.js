$(document).ready(function () {
    if (localStorage.getItem('admintest') == 'MS') {
        //$('.MSMenu').attr('class', 'treeview MSMenu active');
        //$('.MSMenu> .treeview-menu').attr('class', 'treeview-menu menu-open');
        //$('.MSMenu > .treeview-menu').show();
        $('.CMMenu').attr('class', 'treeview MAMenu');
        $('.CMMenu> .treeview-menu').attr('class', 'treeview-menu');
        $('.CMMenu > .treeview-menu').hide();
        //$('.AMMenu').attr('class', 'treeview AMMenu');
        //$('.AMMenu> .treeview-menu').attr('class', 'treeview-menu');
        //$('.AMMenu > .treeview-menu').hide();
        //$('.PMMenu').attr('class', 'treeview MSMenu');
        //$('.PMMenu> .treeview-menu').attr('class', 'treeview-menu');
        //$('.PMMenu > .treeview-menu').hide();
        $('.SC').attr('class', 'treeview SC');
        $('.DB').attr('class', 'treeview DB');
        $('.ComP').attr('class', 'treeview ComP');
        //$('.SMMenu').attr('class', 'treeview MSMenu');
        //$('.SMMenu> .treeview-menu').attr('class', 'treeview-menu');
        //$('.SMMenu > .treeview-menu').hide();
        //$('.Staff').attr('class', 'treeview Staff');
        $('.Customer').attr('class', 'treeview CustomerM');
        $('.GInvoiceM').attr('class', 'treeview GInvoiceM');
        $('.MyAcc').attr('class', 'treeview MyAcc');
    }
    else if (localStorage.getItem('admintest') == 'CM') {
        $('.CMMenu').attr('class', 'treeview CMMenu active');
        $('.Customer').attr('class', 'treeview CustomerM');
        $('.CMMenu> .treeview-menu').attr('class', 'treeview-menu menu-open');
        $('.CMMenu > .treeview-menu').show();
        //$('.MSMenu').attr('class', 'treeview MSMenu');
        //$('.MSMenu> .treeview-menu').attr('class', 'treeview-menu');
        //$('.MSMenu > .treeview-menu').hide();
        //$('.AMMenu').attr('class', 'treeview AMMenu');
        //$('.AMMenu> .treeview-menu').attr('class', 'treeview-menu');
        //$('.AMMenu > .treeview-menu').hide();
        //$('.PMMenu').attr('class', 'treeview MSMenu');
        //$('.PMMenu> .treeview-menu').attr('class', 'treeview-menu');
        //$('.PMMenu > .treeview-menu').hide();
        $('.SC').attr('class', 'treeview SC');
        $('.DB').attr('class', 'treeview DB');
        $('.ComP').attr('class', 'treeview ComP');
        //$('.SMMenu').attr('class', 'treeview MSMenu');
        //$('.SMMenu> .treeview-menu').attr('class', 'treeview-menu');
        //$('.SMMenu > .treeview-menu').hide();
        $('.Staff').attr('class', 'treeview Staff');
        $('.GInvoiceM').attr('class', 'treeview GInvoiceM');
        $('.MyAcc').attr('class', 'treeview MyAcc');
    }   
    else if (localStorage.getItem('admintest') == 'treeview SC') {

        $('.SC').attr('class', 'treeview SC active');
        $('.DB').attr('class', 'treeview DB');
        $('.ComP').attr('class', 'treeview ComP');
        $('.Staff').attr('class', 'treeview Staff');
        //$('.MSMenu').attr('class', 'treeview MSMenu');
        //$('.MSMenu> .treeview-menu').attr('class', 'treeview-menu');
        //$('.MSMenu > .treeview-menu').hide();
        $('.CMMenu').attr('class', 'treeview MSMenu');
        $('.CMMenu> .treeview-menu').attr('class', 'treeview-menu');
        $('.CMMenu > .treeview-menu').hide();
        //$('.AMMenu').attr('class', 'treeview AMMenu');
        //$('.AMMenu> .treeview-menu').attr('class', 'treeview-menu');
        //$('.AMMenu > .treeview-menu').hide();
        //$('.PMMenu').attr('class', 'treeview MSMenu');
        //$('.PMMenu> .treeview-menu').attr('class', 'treeview-menu');
        //$('.PMMenu > .treeview-menu').hide();
        //$('.SMMenu').attr('class', 'treeview MSMenu');
        //$('.SMMenu> .treeview-menu').attr('class', 'treeview-menu');
        //$('.SMMenu > .treeview-menu').hide();
        //$('.AccPMMenu').attr('class', 'treeview MSMenu');
        //$('.AccPMMenu> .treeview-menu').attr('class', 'treeview-menu');
        //$('.AccPMMenu > .treeview-menu').hide();
        $('.Customer').attr('class', 'treeview CustomerM');
        $('.GInvoiceM').attr('class', 'treeview GInvoiceM');
        $('.MyAcc').attr('class', 'treeview MyAcc');
    }
    else if (localStorage.getItem('admintest') == 'treeview DB') {

        $('.DB').attr('class', 'treeview DB active');
        $('.SC').attr('class', 'treeview SC');
        $('.ComP').attr('class', 'treeview ComP');
        $('.Staff').attr('class', 'treeview Staff');
        $('.MSMenu').attr('class', 'treeview MSMenu');
        $('.MSMenu> .treeview-menu').attr('class', 'treeview-menu');
        $('.MSMenu > .treeview-menu').hide();
        $('.CMMenu').attr('class', 'treeview MSMenu');
        $('.CMMenu> .treeview-menu').attr('class', 'treeview-menu');
        $('.CMMenu > .treeview-menu').hide();
        $('.AMMenu').attr('class', 'treeview AMMenu');
        $('.AMMenu> .treeview-menu').attr('class', 'treeview-menu');
        $('.AMMenu > .treeview-menu').hide();
        $('.PMMenu').attr('class', 'treeview MSMenu');
        $('.PMMenu> .treeview-menu').attr('class', 'treeview-menu');
        $('.PMMenu > .treeview-menu').hide();
        $('.SMMenu').attr('class', 'treeview MSMenu');
        $('.SMMenu> .treeview-menu').attr('class', 'treeview-menu');
        $('.SMMenu > .treeview-menu').hide();
        $('.AccPMMenu').attr('class', 'treeview MSMenu');
        $('.AccPMMenu> .treeview-menu').attr('class', 'treeview-menu');
        $('.AccPMMenu > .treeview-menu').hide();
        $('.Customer').attr('class', 'treeview CustomerM');
        $('.GInvoiceM').attr('class', 'treeview GInvoiceM');
        $('.MyAcc').attr('class', 'treeview MyAcc');
    }
    else if (localStorage.getItem('admintest') == 'treeview ComP') {

        $('.ComP').attr('class', 'treeview ComP active');
        $('.SC').attr('class', 'treeview SC');
        $('.DB').attr('class', 'treeview DB');
        $('.Staff').attr('class', 'treeview Staff');
        $('.MSMenu').attr('class', 'treeview MSMenu');
        $('.MSMenu> .treeview-menu').attr('class', 'treeview-menu');
        $('.MSMenu > .treeview-menu').hide();
        $('.CMMenu').attr('class', 'treeview MSMenu');
        $('.CMMenu> .treeview-menu').attr('class', 'treeview-menu');
        $('.CMMenu > .treeview-menu').hide();
        $('.AMMenu').attr('class', 'treeview AMMenu');
        $('.AMMenu> .treeview-menu').attr('class', 'treeview-menu');
        $('.AMMenu > .treeview-menu').hide();
        $('.PMMenu').attr('class', 'treeview MSMenu');
        $('.PMMenu> .treeview-menu').attr('class', 'treeview-menu');
        $('.PMMenu > .treeview-menu').hide();
        $('.SMMenu').attr('class', 'treeview MSMenu');
        $('.SMMenu> .treeview-menu').attr('class', 'treeview-menu');
        $('.SMMenu > .treeview-menu').hide();
        $('.AccPMMenu').attr('class', 'treeview MSMenu');
        $('.AccPMMenu> .treeview-menu').attr('class', 'treeview-menu');
        $('.AccPMMenu > .treeview-menu').hide();
        $('.Customer').attr('class', 'treeview CustomerM');
        $('.GInvoiceM').attr('class', 'treeview GInvoiceM');
        $('.MyAcc').attr('class', 'treeview MyAcc');
    }
    else if (localStorage.getItem('admintest') == 'treeview Staff') {

        $('.Staff').attr('class', 'treeview Staff active');
        $('.ComP').attr('class', 'treeview ComP');
        $('.DB').attr('class', 'treeview DB');
        $('.SC').attr('class', 'treeview SC');
        $('.DB').attr('class', 'treeview DB');
        $('.MSMenu').attr('class', 'treeview MSMenu');
        $('.MSMenu> .treeview-menu').attr('class', 'treeview-menu');
        $('.MSMenu > .treeview-menu').hide();
        $('.CMMenu').attr('class', 'treeview MSMenu');
        $('.CMMenu> .treeview-menu').attr('class', 'treeview-menu');
        $('.CMMenu > .treeview-menu').hide();
        $('.AMMenu').attr('class', 'treeview AMMenu');
        $('.AMMenu> .treeview-menu').attr('class', 'treeview-menu');
        $('.AMMenu > .treeview-menu').hide();
        $('.PMMenu').attr('class', 'treeview MSMenu');
        $('.PMMenu> .treeview-menu').attr('class', 'treeview-menu');
        $('.PMMenu > .treeview-menu').hide();
        $('.SMMenu').attr('class', 'treeview MSMenu');
        $('.SMMenu> .treeview-menu').attr('class', 'treeview-menu');
        $('.SMMenu > .treeview-menu').hide();
        $('.AccPMMenu').attr('class', 'treeview MSMenu');
        $('.AccPMMenu> .treeview-menu').attr('class', 'treeview-menu');
        $('.AccPMMenu > .treeview-menu').hide();
        $('.Customer').attr('class', 'treeview CustomerM');
        $('.GInvoiceM').attr('class', 'treeview GInvoiceM');
        $('.MyAcc').attr('class', 'treeview MyAcc');
    }
    else if (localStorage.getItem('admintest') == 'treeview CustomerM') {
        $('.CustomerM').attr('class', 'treeview CustomerM active');
        $('.Staff').attr('class', 'treeview Staff');
        $('.ComP').attr('class', 'treeview ComP');
        $('.DB').attr('class', 'treeview DB');
        $('.SC').attr('class', 'treeview SC');
        $('.DB').attr('class', 'treeview DB');
        $('.MSMenu').attr('class', 'treeview MSMenu');
        $('.MSMenu> .treeview-menu').attr('class', 'treeview-menu');
        $('.MSMenu > .treeview-menu').hide();
        $('.CMMenu').attr('class', 'treeview MSMenu');
        $('.CMMenu> .treeview-menu').attr('class', 'treeview-menu');
        $('.CMMenu > .treeview-menu').hide();
        $('.AMMenu').attr('class', 'treeview AMMenu');
        $('.AMMenu> .treeview-menu').attr('class', 'treeview-menu');
        $('.AMMenu > .treeview-menu').hide();
        $('.PMMenu').attr('class', 'treeview MSMenu');
        $('.PMMenu> .treeview-menu').attr('class', 'treeview-menu');
        $('.PMMenu > .treeview-menu').hide();
        $('.SMMenu').attr('class', 'treeview MSMenu');
        $('.SMMenu> .treeview-menu').attr('class', 'treeview-menu');
        $('.SMMenu > .treeview-menu').hide();
        $('.AccPMMenu').attr('class', 'treeview MSMenu');
        $('.AccPMMenu> .treeview-menu').attr('class', 'treeview-menu');
        $('.AccPMMenu > .treeview-menu').hide();
        $('.GInvoiceM').attr('class', 'treeview GInvoiceM');
        $('.MyAcc').attr('class', 'treeview MyAcc');
    }
    else if (localStorage.getItem('admintest') == 'treeview User') {
        $('.User').attr('class', 'treeview User active');
        $('.CustomerM').attr('class', 'treeview CustomerM');
        $('.GInvoiceM').attr('class', 'treeview GInvoiceM');
        $('.Staff').attr('class', 'treeview Staff');
        $('.ComP').attr('class', 'treeview ComP');
        $('.DB').attr('class', 'treeview DB');
        $('.SC').attr('class', 'treeview SC');
        $('.DB').attr('class', 'treeview DB');
        $('.MSMenu').attr('class', 'treeview MSMenu');
        $('.MSMenu> .treeview-menu').attr('class', 'treeview-menu');
        $('.MSMenu > .treeview-menu').hide();
        $('.CMMenu').attr('class', 'treeview MSMenu');
        $('.CMMenu> .treeview-menu').attr('class', 'treeview-menu');
        $('.CMMenu > .treeview-menu').hide();
        $('.AMMenu').attr('class', 'treeview AMMenu');
        $('.AMMenu> .treeview-menu').attr('class', 'treeview-menu');
        $('.AMMenu > .treeview-menu').hide();
        $('.PMMenu').attr('class', 'treeview MSMenu');
        $('.PMMenu> .treeview-menu').attr('class', 'treeview-menu');
        $('.PMMenu > .treeview-menu').hide();
        $('.SMMenu').attr('class', 'treeview MSMenu');
        $('.SMMenu> .treeview-menu').attr('class', 'treeview-menu');
        $('.SMMenu > .treeview-menu').hide();
        $('.AccPMMenu').attr('class', 'treeview MSMenu');
        $('.AccPMMenu> .treeview-menu').attr('class', 'treeview-menu');
        $('.AccPMMenu > .treeview-menu').hide();
        $('.MyAcc').attr('class', 'treeview MyAcc');
    }
    else if (localStorage.getItem('admintest') == 'treeview GInvoiceM') {
        $('.GInvoiceM').attr('class', 'treeview GInvoiceM active');
        $('.CustomerM').attr('class', 'treeview CustomerM');
        $('.User').attr('class', 'treeview User');
        $('.Staff').attr('class', 'treeview Staff');
        $('.ComP').attr('class', 'treeview ComP');
        $('.DB').attr('class', 'treeview DB');
        $('.SC').attr('class', 'treeview SC');
        $('.DB').attr('class', 'treeview DB');
        $('.MSMenu').attr('class', 'treeview MSMenu');
        $('.MSMenu> .treeview-menu').attr('class', 'treeview-menu');
        $('.MSMenu > .treeview-menu').hide();
        $('.CMMenu').attr('class', 'treeview MSMenu');
        $('.CMMenu> .treeview-menu').attr('class', 'treeview-menu');
        $('.CMMenu > .treeview-menu').hide();
        $('.AMMenu').attr('class', 'treeview AMMenu');
        $('.AMMenu> .treeview-menu').attr('class', 'treeview-menu');
        $('.AMMenu > .treeview-menu').hide();
        $('.PMMenu').attr('class', 'treeview MSMenu');
        $('.PMMenu> .treeview-menu').attr('class', 'treeview-menu');
        $('.PMMenu > .treeview-menu').hide();
        $('.SMMenu').attr('class', 'treeview MSMenu');
        $('.SMMenu> .treeview-menu').attr('class', 'treeview-menu');
        $('.SMMenu > .treeview-menu').hide();
        $('.AccPMMenu').attr('class', 'treeview MSMenu');
        $('.AccPMMenu> .treeview-menu').attr('class', 'treeview-menu');
        $('.AccPMMenu > .treeview-menu').hide();
        $('.MyAcc').attr('class', 'treeview MyAcc');
    }
    else if (localStorage.getItem('admintest') == 'treeview MyAcc') {
        $('.MyAcc').attr('class', 'treeview MyAcc active');
        $('.GInvoiceM').attr('class', 'treeview GInvoiceM');
        $('.User').attr('class', 'treeview User');
        $('.CustomerM').attr('class', 'treeview CustomerM');
        $('.Staff').attr('class', 'treeview Staff');
        $('.ComP').attr('class', 'treeview ComP');
        $('.DB').attr('class', 'treeview DB');
        $('.SC').attr('class', 'treeview SC');
        $('.DB').attr('class', 'treeview DB');
        $('.MSMenu').attr('class', 'treeview MSMenu');
        $('.MSMenu> .treeview-menu').attr('class', 'treeview-menu');
        $('.MSMenu > .treeview-menu').hide();
        $('.CMMenu').attr('class', 'treeview MSMenu');
        $('.CMMenu> .treeview-menu').attr('class', 'treeview-menu');
        $('.CMMenu > .treeview-menu').hide();
        $('.AMMenu').attr('class', 'treeview AMMenu');
        $('.AMMenu> .treeview-menu').attr('class', 'treeview-menu');
        $('.AMMenu > .treeview-menu').hide();
        $('.PMMenu').attr('class', 'treeview MSMenu');
        $('.PMMenu> .treeview-menu').attr('class', 'treeview-menu');
        $('.PMMenu > .treeview-menu').hide();
        $('.SMMenu').attr('class', 'treeview MSMenu');
        $('.SMMenu> .treeview-menu').attr('class', 'treeview-menu');
        $('.SMMenu > .treeview-menu').hide();
        $('.AccPMMenu').attr('class', 'treeview MSMenu');
        $('.AccPMMenu> .treeview-menu').attr('class', 'treeview-menu');
        $('.AccPMMenu > .treeview-menu').hide();
    }
});

function ActiveClass(e) {
    localStorage.setItem('admintest', $(e).closest('li').attr('class'));
}
function Dashboard(e) {
    localStorage.setItem('admintest', $(e).closest('li').attr('class'));
}
function ChangePassword(e) {
    localStorage.setItem('admintest', $(e).closest('li').attr('class'));
}
function CompanyProfile(e) {
    localStorage.setItem('admintest', $(e).closest('li').attr('class'));
}
function StaffMaster(e) {
    localStorage.setItem('admintest', $(e).closest('li').attr('class'));
}
function CustomerMaster(e) {
    localStorage.setItem('admintest', $(e).closest('li').attr('class'));
}
function InvoiceListM(e) {
    localStorage.setItem('admintest', $(e).closest('li').attr('class'));
}
function MyAccount(e) {
    localStorage.setItem('admintest', $(e).closest('li').attr('class'));
}
function UserMaster(e) {
    localStorage.setItem('admintest', $(e).closest('li').attr('class'));
}
function ServiceCategory(e) {
    localStorage.setItem('admintest', $(e).closest('li').attr('class'));
}
function ManageService(e) {
    localStorage.setItem('admintest', $(e).closest('li').attr('class'));
}