<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="Z_Report.aspx.cs" Inherits="Pages_Z_Report" %>
<%@ Register src="/Pages/IFrame.ascx" TagName="frame" TagPrefix="uc2" %>  
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>Z Report
            <%--<a class="btn btn-sm btn-warning pull-right" onclick="PrintZ_Report(0)">Z Report</a>--%>
        </h1>
    </section>
    <div class="content" id="divForm" ondragstart="return false;" ondrop="return false;">
        <div class="row">
            <div class="col-md-12">
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <b>Z Report</b>
                    </div>
                    <div class="panel-body">
                        <div class="row">
                             <div class="col-md-2 form-group">
                                 <label>Select Date</label>
                                <input type="text" id="txtDate" onchange="getShiftList()" style="text-align:left" class="form-control input-sm date" readonly="readonly" />
                            </div>
                            <div class="col-md-3 form-group">
                                <label>Select Terminal</label>
                                <select id="ddlTerminal" onchange="getShiftList()" class="form-control input-sm">
                                    <option value="0">All</option>
                                    <option value="1">Terminal 1</option>
                                    <option value="2">Terminal 2</option>
                                </select>
                            </div>
                             <div class="col-md-3  form-group">
                                 <label>Select Shift</label>
                                <select id="ddlAllShift" class="form-control input-sm">
                                    <option value="0">All Shift</option>
                                </select>
                            </div>
                           
                            
                            <div class="col-md-3 form-group" style="padding-top:30px">
                                <label></label>
                                <button type="button" id="btnZReport" onclick="SearchZ_Report();" class="btn btn-sm catsearch-btn">Search</button>
                                <button type="button" id="btnZReportPrint" onclick="PrintZ_Report();" style="width:90px" class="btn btn-sm btn-success">Print</button>
                            </div>
                        </div>
                    </div>
                    <div style="text-align:center;">
                         <uc2:frame ID="frame1" runat="server" />
                    </div>
                   
                </div>
            </div>
        </div>
    </div>
      
</asp:Content>

