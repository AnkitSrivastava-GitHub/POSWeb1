<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="RoyaltyMaster.aspx.cs" Inherits="Pages_RoyaltyMaster" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>Reward Master</h1>
    </section>
    <div class="content" id="divForm" ondragstart="return false;" ondrop="return false;">
        <div class="row">
            <div class="col-md-6">
                <input type="hidden" id="hdnRoyaltyId" />
                <input type="hidden" id="hdnAMtRoyaltyId" />
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <b>Redeem Reward Details</b>
                    </div>
                    <div class="panel-body" id="panelRoyaltyDetail">
                        <div class="row">
                            <label class="col-md-5 form-group">
                                Amount per Reward point<span class="required"> *</span>
                            </label>
                            <div class="col-md-7 form-group">
                                <div class="input-group">
                                    <span class="input-group-addon input-sm symbol"></span>
                                    <input type="text" id="txtAmtPerRoyaltyPoint" onclick="this.select();" onselectstart="return false" oncut="return false" oncopy="return false" onpaste="return false" ondrag="return false" ondrop="return false" class="form-control input-sm text-right" maxlength="9" placeholder="Amount" value="0.00" onkeypress="return isNumberDecimalKey(event,this)" />
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <label class="col-md-5 form-group">
                                Minimum Order Amount<span class="required"> *</span>
                            </label>
                            <div class="col-md-7 form-group">
                                <div class="input-group">
                                    <span class="input-group-addon input-sm symbol"></span>
                                    <input type="text" id="txtMinOrderAmt" onclick="this.select();" onselectstart="return false" oncut="return false" oncopy="return false" onpaste="return false" ondrag="return false" ondrop="return false" class="form-control input-sm text-right" maxlength="9" placeholder="Amount" value="0.00" onkeypress="return isNumberDecimalKey(event,this)" />
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <label class="col-md-5 form-group">
                                Status
                            </label>
                            <div class="col-md-7 form-group">
                                <select id="ddlStatus" class="input-sm form-control">
                                    <option value="1" selected="selected">Active</option>
                                    <option value="0">Inactive</option>
                                </select>
                            </div>
                        </div>
                        <hr />
                        <div class="row">
                            <div class="col-md-12 form-group">
                                <div class="pull-right">
                                    <%--<button type="button" id="btnSave" onclick="InsertRoyaltyDetails();" class="btn btn-sm catsave-btn">Save</button>--%>
                                    <button type="button" id="btnUpdate" onclick="UpdateRoyalty();" class="btn btn-sm catsave-btn">Update</button>
                                    <%--<button type="button" id="btnReset" onclick="Reset();" class="btn btn-sm catreset-btn">Reset</button>--%>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-md-6">
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <b>Amount wise Reward Details</b>
                    </div>
                    <div class="panel-body" id="panelROyaltyPointAmt">

                        <div class="row">
                            <label class="col-md-4 form-group">
                                Amount<span class="required"> *</span>
                            </label>
                            <div class="col-md-8 form-group">
                                <div class="input-group">
                                    <span class="input-group-addon input-sm symbol"></span>
                                    <input type="text" id="txtRoyaltyApointsAsPerAmt" onclick="this.select();" onselectstart="return false" oncut="return false" oncopy="return false" onpaste="return false" ondrag="return false" ondrop="return false" class="form-control input-sm text-right" maxlength="9" placeholder="Amount" value="0.00" onkeypress="return isNumberDecimalKey(event,this)" />
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <label class="col-md-4 form-group">
                                Reward points<span class="required"> *</span>
                            </label>
                            <div class="col-md-8 form-group">
                                <input type="text" onclick="this.select();" onselectstart="return false" maxlength="5" oncut="return false" oncopy="return false" onpaste="return false" ondrag="return false" ondrop="return false" id="txtRoyaltyPoints" class="form-control input-sm text-right" placeholder="Reward Points" value="0" onchange="return IsValidInteger(this);" onkeypress="return event.charCode >= 48 &amp;&amp; event.charCode <= 57" />
                            </div>
                        </div>
                        <div class="row">
                            <label class="col-md-4 form-group" style="white-space:nowrap;">
                                Minimum Order Amount<span class="required"> *</span>
                            </label>
                            <div class="col-md-8 form-group">
                                <div class="input-group">
                                    <span class="input-group-addon input-sm symbol"></span>
                                    <input type="text" id="txtMinOrderAmtForRoyalty" onclick="this.select();" onselectstart="return false" oncut="return false" oncopy="return false" onpaste="return false" ondrag="return false" ondrop="return false" class="form-control input-sm text-right" maxlength="9" placeholder="Minimum Order Amount" value="0.00" onkeypress="return isNumberDecimalKey(event,this)" />
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <label class="col-md-4 form-group">
                                Status
                            </label>
                            <div class="col-md-8 form-group">
                                <select id="ddlAmtRoyaltyStatus" class="input-sm form-control">
                                    <option value="1" selected="selected">Active</option>
                                    <option value="0">Inactive</option>
                                </select>
                            </div>
                        </div>
                        <hr />
                        <div class="row">
                            <div class="col-md-12 form-group">
                                <div class="pull-right">
                                    <%--                                    <button type="button" id="btnAmtSave" onclick="InsertRoyaltyDetails();" class="btn btn-sm catsave-btn">Save</button>--%>
                                    <button type="button" id="btnAmtUpdate" onclick="UpdateAmtRoyalty();" class="btn btn-sm catsave-btn">Update</button>
                                    <%--<button type="button" id="btnAmtReset" onclick="Reset();" class="btn btn-sm catreset-btn">Reset</button>--%>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

