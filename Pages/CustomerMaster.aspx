<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="CustomerMaster.aspx.cs" Inherits="Pages_CustomerMaster" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <section class="content-header">
        <h1>Customer Master</h1>
    </section>
    <div class="content" id="divForm"  ondragstart="return false;" ondrop="return false;">
        <div class="row">
              <div class="col-md-12">
                <input type="hidden" id="hdnCustomerId"/>
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <b>Add Customer</b>
                    </div>
                    <div class="panel-body" id="panelStoreDetail">
                         <div class="row">
                            <label class="col-md-2 form-group">
                               First Name<span class="required"> *</span>
                            </label>
                            <div class="col-md-4 form-group">
                                <input type="text" id="txtfname" class="form-control input-sm" placeholder="Enter Customer First Name" />
                            </div>
                              <label class="col-md-2 form-group">
                               Last Name
                            </label>
                            <div class="col-md-4 form-group">
                                <input type="text" id="txtlname" class="form-control input-sm" placeholder="Enter Customer last Name" />
                            </div>                          
                        </div>
                        <div class="row">
                             <label class="col-md-2 form-group">
                               Mobile No.<span class="required"> *</span>
                            </label>
                            <div class="col-md-4 form-group">
                                <input type="text" id="txtmob" class="form-control input-sm" placeholder="Enter Mobile No." maxlength="10" onkeypress="NumericInput(event)"/>
                            </div>  
                             <label class="col-md-2 form-group">
                                EmailID
                            </label>
                            <div class="col-md-4 form-group">
                               <input type="text" id="txtemail" class="form-control input-sm" placeholder="Enter EmailID" />
                            </div>
                        </div>
                         <div class="row">
                             <label class="col-md-2 form-group">
                                 Address
                            </label>
                            <div class="col-md-4 form-group">
                                <textarea type="text" id="txtaddress" style="resize:none;" class="form-control input-sm" placeholder="Enter Address" rows="5" ></textarea>
                            </div>
                               <label class="col-md-2 form-group">
                                 City
                            </label>
                            <div class="col-md-4 form-group">
                               <input type="text" id="txtcity" class="form-control input-sm" placeholder="Enter City" />
                            </div>
                              <label class="col-md-2 form-group">
                                  State
                            </label>
                            <div class="col-md-4 form-group">
                                <select id="ddlstate" class="form-control input-sm">
                                    <option value="1">Select State</option>
                                </select>
                            </div>
                             <label class="col-md-2 form-group">
                               ZipCode
                            </label>
                            <div class="col-md-4 form-group">
                                <input type="text" id="txtzip" class="form-control input-sm" placeholder="Enter Zip Code" maxlength="6" onkeypress="NumericInput(event)"/>
                            </div>
                        </div>
                         <div class="row">
                             <label class="col-md-2 form-group">
                               DOB
                            </label>
                            <div class="col-md-4 form-group">
                                <input type="text" id="txtdob" class="form-control input-sm" placeholder="Enter DOB" readonly/>
                            </div>  
                        </div>                               
                        <hr />
                        <div class="row">
                            <div class="col-md-12 form-group">
                                <div class="pull-right">
                                    <button type="button" id="btnSave" onclick="InsertCustomer();" class="btn btn-sm btn-success">Save</button>
                                    <button type="button" id="btnUpdate" onclick="UpdateCustomer();" class="btn btn-sm btn-primary" style="display: none">Update</button>
                                    <button type="button" id="btnReset" onclick="Reset();" class="btn btn-sm btn-default">Reset</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

