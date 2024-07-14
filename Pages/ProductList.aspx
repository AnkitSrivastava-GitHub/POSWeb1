<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="ProductList.aspx.cs" Inherits="Pages_ProductList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <style>
        .modal-lg {
            width: 600px !important;
        }

        button {
            font-size: 18px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>Product List
            <a href="/Pages/ProductMaster.aspx" style="margin-left: 10px;" class="btn btn-sm btn-warning pull-right">Add New Product</a>
            <button type="button" onclick="OpenBulkModal()" id="btnBulkChange" class="btn btn-sm btn-success pull-right">Bulk Change</button>
        </h1>
    </section>
    <div class="content" id="divForm" ondragstart="return false;" ondrop="return false;">
        <div class="row">
            <div class="col-md-12">
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <b>Search Criteria</b>
                    </div>
                    <div class="panel-body">
                        <div class="row form-group" style="margin-bottom: 10px;">
                            <div class="col-md-3">
                                <input type="text" id="txtPname" class="form-control input-sm" maxlength="100" placeholder="Product Name" />
                            </div>
                            <div class="col-md-2">
                                <select id="ddlDept" class="form-control input-sm">
                                    <option value="0">All Department</option>
                                </select>
                            </div>
                            <div class="col-md-2">
                                <select id="ddlbrand" class="form-control input-sm">
                                    <option value="0">All Brand</option>
                                </select>
                            </div>
                            <div class="col-md-2">
                                <select id="ddlcategory" class="form-control input-sm">
                                    <option value="0">All Category</option>
                                </select>
                            </div>
                            <div class="col-md-2">
                                <select id="ddlStatus" class="form-control input-sm">
                                    <option value="2">All Status</option>
                                    <option value="1" selected="selected">Active</option>
                                    <option value="0">Inactive</option>
                                </select>
                            </div>
                            <div class="col-md-1">
                                <button id="btnSearch" type="button" onclick="MasterBindProductList(1);" class="btn btn-sm catsearch-btn pull-right">Search</button>
                            </div>
                        </div>
                        <div class="table-responsive">
                            <table id="tblProductList" class="table table-striped table-bordered well" style="display:none;">
                                <thead>
                                    <tr class="thead">
                                        <td class="chkCheckBox text-center" style="width: 3%; vertical-align: middle;">
                                            <input type="checkbox" id="check-all" />
                                        </td>
                                        <td class="Action" style="width: 50px; text-align: center; vertical-align: middle;">Action</td>
                                        <td class="ProductId" style="width: 50px; text-align: center; vertical-align: middle;display:none;">ProductId</td>
                                        <td class="ProductName" style="white-space: nowrap; text-align: center; vertical-align: middle;">Product Name</td>
                                        <td class="GroupName" style="white-space: nowrap; text-align: center; display: none;">Group Name</td>
                                        <td class="Dept" style="width: 150px; text-align: center; vertical-align: middle;">Department</td>
                                        <td class="Brand" style="width: 150px; text-align: center; vertical-align: middle;">Brand</td>
                                        <td class="Category1" style="width: 250px; text-align: center; vertical-align: middle;">Category</td>
                                         <td class="CurrentStock" style="width: 250px; text-align: center; vertical-align: middle;">Current Stock QTY</td>
                                        <td class="AlertStock" style="width: 250px; text-align: center; vertical-align: middle;">Alert Stock QTY</td>
                                        <td class="CreationDetail" style="width: 325px; text-align: center; vertical-align: middle;">Updated By Detail</td>
                                        <td class="Status" style="width: 100px; text-align: center; vertical-align: middle;">Status</td>
                                    </tr>
                                </thead>
                                <tbody>
                                </tbody>
                            </table>
                            <h5 class="well text-center" id="EmptyTable" style="display: none">No data available.</h5>
                        </div>
                        <div class="form-group row" style="padding-bottom: 0px; margin-bottom: 0px; margin-top: 10px;" id="DivPager">
                            <div class="col-md-1">
                                <select class="form-control border-primary input-sm" style="display:none;" id="ddlPageSize" onchange="MasterBindProductList(1)">
                                    <option value="10">10</option>
                                    <option value="50">50</option>
                                    <option value="100">100</option>
                                    <option value="500">500</option>
                                    <option value="1000">1000</option>
                                    <option value="0">All</option>
                                </select>
                            </div>
                            <div class="col-md-8">
                                <div class="Pager" id="Pager"></div>
                            </div>
                            <div class="col-md-3 text-right">
                                <span id="spSortBy" style="color: red; font-size: small;"></span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="ProductPackingsModal" role="dialog" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog modal-dialog-centered modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title" id="exampleModalLongTitle" style="font-weight: 700;">Packing Details
                        <img src="../Images/del.png" class="del-btnp" style="top: 8px" onclick="CloseModalPackingList()" />
                    </h4>
                </div>
                <div class="modal-body" id="DivPackingList" style="padding: 10px;">
                    <div class="table-responsive">
                        <table id="tblProductPackingList" class="table table-striped table-bordered well" style="margin-bottom: 0px;">
                            <thead>
                                <tr class="thead">
                                    <td class="Action" style="text-align: center; width: 50px; display: none">Action</td>
                                    <td class="Packing" style="text-align: center; width: 150px; display: none">Packing Name</td>
                                    <td class="NoOfPieces" style="text-align: center; width: 150px;">No. of pieces</td>
                                    <td class="PieceSize" style="text-align: center; width: 120px; display: none;">Piece Size</td>
                                    <td class="Barcode" style="text-align: center; display: none">Barcode</td>
                                    <td class="CP" style="text-align: center; width: 120px; white-space:nowrap ">Cost Price (<span class="symbol"></span>)</td>
                                    <td class="SP" style="text-align: center; width: 120px;white-space:nowrap">Unit Price (<span class="symbol"></span>)</td>
                                    <td class="SecondaryUnitPrice" style="text-align: center; width: 140px; white-space: nowrap;">Secondary Unit Price(<span class="symbol"></span>)</td>
                                    <td class="TaxId" style="display: none">TaxId</td>
                                    <td class="Tax" style="text-align: center; width: 100px; display: none;">Tax(%)</td>
                                    <td class="WebAvailability" style="text-align: center; width: 100px; display: none;">Available on Web ?</td>
                                    <td class="MS" style="text-align: center; width: 120px; display: none;">Manage Stock</td>
                                    <td class="InStock" style="text-align: center; width: 120px; display: none;">In Stock</td>
                                    <td class="LowStock" style="text-align: center; width: 120px; display: none;">Low Stock</td>
                                    <td class="PreviewImage" style="text-align: center; width: 120px; display: none;">View Image</td>
                                    <td class="ImageName" style="text-align: center; width: 120px; display: none;">Image Name</td>
                                    <td class="Status" style="text-align: center; width: 120px;">Status</td>
                                </tr>
                            </thead>
                        </table>
                        <h5 class="well text-center" id="PackingEmptyTable" style="display: none">No data available.</h5>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="modal fade" id="ModalPackingImage" role="dialog" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog modal-dialog-centered" style="width: 300px" role="document">
            <div class="modal-content card-p">
                <div class="modal-header cardm-head">
                    <h5 class="modal-title">Packing Image
                        <img src="../Images/del.png" class="del-btnp" onclick="ClosePackingImageModal()" />
                    </h5>
                </div>
                <div class="modal-body" style="padding-left: 0px; padding-right: 0px;">
                    <div class="row">
                        <div class="col-md-12">
                            <img id="imgPackingImage" src="#" class="image" style="height: 100%; width: 100%">
                        </div>
                    </div>
                </div>
                <div class="modal-footer text-center" style="text-align: center">
                    <%--<button type="button" class="btn btn-sm btn-danger" style="width: 100px" onclick="CloseCardTypeModal()">BACK</button>
                    <button type="button" class="btn btn-sm btn-success" style="width: 100px" onclick="CreditcardPay()">PAY</button>--%>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="BulkChangeModal" role="dialog" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog modal-dialog-centered modal-lg" style="width: 1000px !important" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="BulkChangeCLose">Bulk Change In Product Details <span style="color:white;"> (Only Product with single packing update from Bulk Product)</span>
                        <img src="../Images/del.png" class="del-btnp" style="top: 8px;right:10px" onclick="CloseBulkModal()" />
                    </h5>
                </div>
                <div class="modal-body" id="" style="padding: 10px 20px;">
                    <div class="row form-group">
                        <div class="col-lg-3">
                            <label>Deparment</label>
                            <select id="ddlBulkDept" class="form-control input-sm" style="width: 100%">
                                <option value="0">select Department</option>
                            </select>
                        </div>
                        <div class="col-lg-3">
                            <label>Brand</label>
                            <select id="ddlBulkbrand" class="form-control input-sm" style="width: 100%">
                                <option value="0">Select Brand</option>
                            </select>
                        </div>
                        <div class="col-lg-3">
                            <label>Category</label>
                            <select id="ddlBulkcategory" class="form-control input-sm" style="width: 100%">
                                <option value="0">Select Category</option>
                            </select>
                        </div>
                        <div class="col-lg-3">
                            <label class="col-md-3" style="white-space: nowrap">Age Restriction </label>
                            <select id="ddlBulkAgeRest" style="padding-top: 2px;width: 100%" class="form-control input-sm">
                                <option value="0">Select Age Restriction</option>
                            </select>
                        </div>
                    </div>
                    <div class="row form-group">
                        <div class="col-md-2">
                            <label>Tax</label>
                            <select id="ddlBulkTax" class="form-control input-sm" style="width: 100%">
                                <%--<option value="0">Select Tax</option>--%>
                            </select>
                        </div>
                        <div class="col-md-2">
                            <label>Product QTY  </label>
                            <input type="text" id="txtBulkProductSize" onpaste="return numberonly(this)" autocomplete="off" class="form-control input-sm" maxlength="5" onchange="return IsValidDecimal(this);" onkeypress="return isNumberDecimalKey(event,this)" placeholder="e.g. 750" />
                        </div>
                        <div class="col-md-2">
                            <label>Unit </label>
                            <select id="ddlBulkMeasureUnit" style="width: 100%" class="form-control">
                                <option value="0">Product Size</option>
                            </select>
                        </div>
                        <div class="col-md-2">
                            <label>Cost Price</label>
                            <div class="input-group">
                                <span class="input-group-addon input-sm">$</span>
                                <input type="text" id="txtCostPrice" onclick="this.select();" onselectstart="return false" oncut="return false" oncopy="return false" onpaste="return false" ondrag="return false" ondrop="return false" class="form-control input-sm text-right" maxlength="9" value="0.00" onkeypress="return isNumberDecimalKey(event,this)" />
                            </div>
                        </div>
                        <div class="col-md-2">
                            <label>Unit Price</label>
                            <div class="input-group">
                                <span class="input-group-addon input-sm">$</span>
                                <input type="text" id="txtSellingPrice" onclick="this.select();" onselectstart="return false" oncut="return false" oncopy="return false" onpaste="return false" ondrag="return false" ondrop="return false" class="form-control input-sm text-right" maxlength="9" value="0.00" onchange="fillsecondPrice(this);" onkeypress="return isNumberDecimalKey(event,this)" />
                            </div>
                        </div>
                        <div class="col-md-2  form-group">
                            <label class="text-nowrap">Sec. Unit Price</label>
                            <div class="input-group">
                                <span class="input-group-addon input-sm">$</span>
                                <input type="text" id="txtSecondaryUnitPrice" onclick="this.select();" onselectstart="return false" oncut="return false" oncopy="return false" onpaste="return false" ondrag="return false" ondrop="return false" class="form-control input-sm text-right" maxlength="9" value="0.00" onchange="return IsValidDecimal(this);" onkeypress="return isNumberDecimalKey(event,this)" />
                            </div>
                        </div>
                        <div class="col-md-2">
                            <label>Status</label>
                            <select id="ddlBulkStatus" class="form-control input-sm" style="width:100%">
                                <option value="2" selected="selected">Select</option>
                                <option value="1">Active</option>
                                <option value="0">Inactive</option>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" style="margin-right: 17px;" onclick="ChangeProductInBulk(0)" class="btn btn-primary">Change In Bulk</button>
                </div>
            </div>
        </div>
    </div>
    <div>
        <dialog>
           

        </dialog>
    </div>
    <script type="text/javascript">
        $("#check-all").change(function () {
            if ($(this).prop("checked")) {
                $("#tblProductList input:checkbox:not(:disabled)").prop('checked', $(this).prop("checked"));
            }
            else {
                $("#tblProductList input:checkbox").prop('checked', $(this).prop("checked"));
            }
            CountSelectedRow();
        });
    </script>
</asp:Content>

