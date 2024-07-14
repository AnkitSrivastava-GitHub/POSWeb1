<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="CouponMaster.aspx.cs" Inherits="Pages_CouponMaster" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>Coupon Master
            <a href="/Pages/ShowCouponMaster.aspx" class="btn btn-sm btn-warning pull-right">Coupon List</a>
        </h1>
    </section>
    <div class="content" id="divForm" ondragstart="return false;" ondrop="return false;">
        <div class="row">
            <div class="col-md-12">
                <input type="hidden" id="hdnCouponId" />
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <b>Coupon Details</b>
                    </div>
                    <div class="panel-body" id="panelStoreDetail">
                        <div class="row">
                            <label class="col-md-2 form-group">
                                Coupon Code<span class="required"> *</span>
                            </label>
                            <div class="col-md-4 form-group">
                                <input type="text" maxlength="25" id="txtCouponCode" placeholder="Enter Coupon Code" style="height: 34px;" class="form-control input-sm" />
                            </div>
                            <label class="col-md-2 form-group">
                                Coupon Type <span class="required">*</span>
                            </label>
                            <div class="col-md-4 form-group">
                                <select id="ddlCouponType" onchange="Changedisc();" class="form-control input-sm" style="height: 34px;">
                                    <option value="2">Select</option>
                                    <option value="1">Fixed</option>
                                    <option value="0">Percentage</option>
                                </select>
                            </div>
                        </div>

                        <div class="row">
                            <label class="col-md-2 form-group">
                                Discount<span class="required"> *</span>
                            </label>
                            <div class="col-md-4 form-group">
                                <div class="input-group">
                                     <span class="input-group-addon input-md spn_disc symbol" style="font-weight:bold"></span>
                                    <input type="text" onkeypress="return isNumberDecimalKey(event, this)" id="txtDiscount" onkeyup="Checkdisc(this);" maxlength="9" class="form-control input-sm" placeholder="0.00" value="0.00" style="text-align: right;" />
                                  <span class="input-group-addon input-md spn_disc1" style="font-weight:bold; display:none">%</span>
                                </div>
                        </div>
                        <label class="col-md-2 form-group" style="white-space: nowrap;">
                            Minimum Order Amount
                        </label>
                        <div class="col-md-4 form-group">
                            <div class="input-group">
                                <span class="input-group-addon input-md symbol" style="font-weight:bold"></span>
                                <input type="text" id="txtAmount" maxlength="9" class="form-control input-sm" onkeypress="return isNumberDecimalKey(event, this)"  placeholder="0.00" value="0.00" style="text-align: right;" />
                                
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <label class="col-md-2 form-group">
                            Start Date<span class="required"> *</span>
                        </label>
                        <div class="col-md-4 form-group">
                            <input type="text" id="txtStartDate" class="form-control input-sm date" placeholder="Start Date" />
                        </div>
                        <label class="col-md-2 form-group">
                            End Date<span class="required"> *</span>
                        </label>
                        <div class="col-md-4 form-group">
                            <input type="text" id="txtEndDate" class="form-control input-sm date" placeholder="End Date" />
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-6">
                            <div class="row">
                                <label class="col-md-4 form-group">
                                    Status
                                </label>
                                <div class="col-md-8 form-group">
                                    <select id="ddlStatus" class="form-control input-sm">
                                        <option value="1">Active</option>
                                        <option value="0">Inactive</option>
                                    </select>
                                </div>
                            </div>
                            <div class="row">
                                <label class="col-md-4 form-group">
                                    Coupon Description
                                </label>
                                <div class="col-md-8 form-group">
                                    <textarea id="txtDiscription" maxlength="200" style="/*max-height:180px;max-width:395px;min-height: 84px; min-width: 395px;*/resize:none" placeholder="Enter Coupon Description" class="form-control input-sm" rows="2"></textarea>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="row">
                                <label class="col-md-4 form-group">
                                    Terms & Conditions
                                </label>
                                <div class="col-md-8 form-group">
                                    <textarea id="txtTermsDescription" style="/*max-height:180px;max-width:390px;min-height: 84px; min-width: 395px;*/resize:none;" maxlength="250" placeholder="Enter Terms & Conditions" class="form-control input-sm" rows="3"></textarea>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row" style="display:none;">
                    </div>
                    <div class="row" style="display:none;">
                        <label class="col-md-2 form-group">
                            Select Store<span class="required"> *</span>
                        </label>
                        <div class="col-md-10 form-group form-check">
                            <div class="row" id="divStoreList">
                            </div>
                        </div>

                    </div>

                    <hr />
                    <div class="row">
                        <div class="col-md-12 form-group">
                            <div class="pull-right">
                                <button type="button" id="btnSave" onclick="AddCoupon()" class="btn btn-sm catsave-btn">Save</button>
                                <button type="button" id="btnUpdate" onclick="UpdateCoupon()" class="btn btn-sm catsave-btn" style="display: none">Update</button>
                                <button type="button" id="btnReset" onclick="Reset();" class="btn btn-sm catreset-btn">Reset</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    </div>
</asp:Content>

