<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="ChangePassword.aspx.cs" Inherits="Pages_ChangePassword" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="content" id="divForm"  ondragstart="return false;" ondrop="return false;">
        <div class="row">
            <div class="col-md-3">
            </div>
            <div class="col-md-6">
                <input type="hidden" id="hdnBrandId" />
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <b>Change Password</b>
                    </div>
                    <div class="panel-body" id="panelStoreDetail">
                        <div class="row">
                            <label class="col-md-4 form-group">
                                Current Password<span class="required"> *</span>
                            </label>
                            <div class="col-md-8 form-group">
                                <input type="text" id="txtCurrentPassword" class="form-control input-sm" placeholder="Enter Current Password" />
                            </div>
                        </div>
                        <div class="row">
                            <label class="col-md-4 form-group">
                                New Password<span class="required"> *</span>
                            </label>
                            <div class="col-md-8 form-group">
                                <input type="text" id="txtNewPassword" class="form-control input-sm" placeholder="Enter New Password" />
                            </div>
                        </div>
                        <div class="row">
                            <label class="col-md-4 form-group" style="white-space:nowrap;">
                                Confirm New Password<span class="required"> *</span>
                            </label>
                            <div class="col-md-8 form-group">
                                <input type="text" id="txtConfirmPassword" class="form-control input-sm" placeholder="Enter Confirm New Password" />
                            </div>
                        </div>
                        <hr />
                        <div class="row">
                            <div class="col-md-12">
                                <div class="pull-right">
                                    <button type="button" id="btnUpdate" onclick="" class="btn btn-sm btn-primary">Update Password</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
            </div>
        </div>
    </div>
</asp:Content>

