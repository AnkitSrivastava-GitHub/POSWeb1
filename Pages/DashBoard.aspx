<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="DashBoard.aspx.cs" Inherits="Pages_Home" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <style type="text/css">
        .btnInvoice2 {
             border: 3px solid #3b8981 !important;
             font-size: 15px;
             margin-left: 2% !important;
             margin-bottom: 15px !important;
             margin-right: 1.5% !important;
             width: 21% !important;
             min-height: 70px !important;
             background-color: #fff !important;
             color: #349b91 !important;
             white-space: normal !important;
             display: inline !important;
        }

        .btnInvoice2:hover {
            background-color: #3b8981 !important;
            border: 3px solid #196a62 !important;
            color: #fff !important;
            -webkit-box-shadow: 0 0 10px rgba(0, 0, 0, 0.15);
            -moz-box-shadow: 0 0 10px rgba(0, 0, 0, 0.15);
            box-shadow: 2px 7px 10px rgba(16, 16, 16, 0.48);
        }
    </style>
    <script type="text/javascript">
        function preventBack() {
            window.history.forward();
        }

        setTimeout("preventBack()", 0);

        window.onunload = function () { null }; 
        function redirectProductMaster() {
            window.location.href = '/Pages/ProductList.aspx';
        }
        function redirectSKUMaster() {
            window.location.href = '/Pages/SKUList.aspx';
        }
        function redirectSchemeMaster() {
            window.location.href = '/Pages/SchemeList.aspx';
        }
        function redirectInvoicePop() {
            window.location.href = '/Pages/POSScreen.aspx';
        }


    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="row">
        <div class="col-md-12">
            <div class="panel panel-default">

                <div class="panel-body" >
                    <div class="row">

                        <div class="col-md-12 form-group">
                            <button type="button" onclick="redirectInvoicePop()" runat="server" id="btnCashier" class="btn btn-sm btn-primary btnInvoice2 sameHightCategory" style="height: 160px;">
                                <i class="fa fa-plus-circle fa-4x"></i>
                                <h4>Cashier</h4>
                            </button>
                            <button type="button" onclick="redirectProductMaster()" runat="server" id="btnProductMaster" class="btn btn-sm btn-primary btnInvoice2 sameHightCategory" style="height: 160px;">
                                <i class="fa fa-th-list fa-4x"></i>
                                <h4>Product Master</h4>
                            </button>
                            <button type="button" onclick="redirectSKUMaster()" runat="server" id="btnSKUMaster" class="btn btn-sm btn-primary btnInvoice2 sameHightCategory" style="height: 160px;">
                                <i class="fa fa-th-list fa-4x"></i>
                                <h4>SKU Master</h4>
                            </button>
                            <button type="button" onclick="redirectSchemeMaster()" runat="server" id="btnSchemeMaster" class="btn btn-sm btn-primary btnInvoice2 sameHightCategory" style="height: 160px;">
                                <i class="fa fa-th-list fa-4x"></i>
                                <h4>Scheme Master</h4>
                            </button>
                           <%-- <button type="button" onclick="redirectsalereport()" class="btn btn-sm btn-primary btnInvoice2 sameHightCategory" style="height: 160px;">
                                <i class="fa fa-list-ul fa-4x"></i>
                                <h4>Sale Report</h4>
                            </button>
                            <button type="button" onclick="redirectpurchasereport()" class="btn btn-sm btn-primary btnInvoice2 sameHightCategory" style="height: 160px;">
                                <i class="fa fa-th-list fa-4x"></i>
                                <h4>Purchase Report</h4>
                            </button>
                            <button type="button" onclick="redirectcombinevat()" class="btn btn-sm btn-primary btnInvoice2 sameHightCategory" style="height: 160px;">
                                <i class="fa fa-clone fa-4x"></i>
                                <h4>Combine VAT Report</h4>
                            </button>
                            <button type="button" onclick="redirectcustomerlist()" class="btn btn-sm btn-primary btnInvoice2 sameHightCategory" style="height: 160px;">
                                <i class="fa fa-male fa-4x"></i>
                                <h4>Customer List</h4>
                            </button>--%>

                        </div>

                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

