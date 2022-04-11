<%@ WebHandler Language="C#" Class="pf_handler" %>


using System;
using System.Windows;
using System.Data;
using System.Web;
using Newtonsoft.Json;
using System.IO;
using System.Web.SessionState;
using System.Configuration;
using System.Drawing;
using System.Text;
using System.Xml;
using System.Net;
using System.Text.RegularExpressions;
using System.Web.Security;
using System.Data.Odbc;
using System.Collections;
using System.Collections.Generic;
using System.Data.SqlClient;

public class pf_handler : IHttpHandler, IRequiresSessionState
{

    public void ProcessRequest(HttpContext context)
    {
        int EventId = Convert.ToInt32(context.Request.QueryString["EventId"]);
        int edit_pf_id = Convert.ToInt32(context.Request.QueryString["pfid"]);
        string JsonEventResult = string.Empty;

        switch (EventId)
        {
            case 1:
                addData(context);
                break;
            case 2:
                //update_data(context);
                break;
            case 3:
                getdata(context);
                break;
            case 4:
                readforupdate(context, edit_pf_id);
                break;
            case 5:
                update_click(context, edit_pf_id);
                break;
            case 6:
                delete_click(context, edit_pf_id);
                break;
            default:
                break;
        }

    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

    public void addData(HttpContext context)
    {

        string add_pf_name = Convert.ToString(context.Request["family_name"]);
        string add_pf_dol = Convert.ToString(context.Request["pf_dol"]);
        //bool add_pf_isactive = Convert.ToBoolean(context.Request["pf_isactive"]);

        bool add_pf_isactive = true;
        if (Convert.ToString(context.Request["pf_isactive"]) == "pf_active")
            add_pf_isactive = true;
        else if (Convert.ToString(context.Request["pf_isactive"]) == "pf_inactive")
            add_pf_isactive = false;

        string add_pf_app = Convert.ToString(context.Request["pf_app"]);

        // Taking out out connectionstring in a variable from web config
        try
        {

            string connstr = ConfigurationManager.ConnectionStrings["Project_Inventrix_string"].ConnectionString;
            using (SqlConnection con = new SqlConnection(connstr))
            {
                using (SqlCommand cmd = new SqlCommand("pf_crud", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add("@pf_name", SqlDbType.VarChar).Value = add_pf_name;
                    cmd.Parameters.Add("@pf_dol", SqlDbType.Date).Value = add_pf_dol;
                    cmd.Parameters.Add("@pf_isactive", SqlDbType.Bit).Value = add_pf_isactive;
                    cmd.Parameters.Add("@pf_app", SqlDbType.VarChar).Value = add_pf_app;
                    cmd.Parameters.Add("@pf_opr_flag", SqlDbType.VarChar).Value = "insert";
                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }
        }
        catch (Exception e)
        {

        }
    }




    public void readforupdate(HttpContext context, int edit_pf_id)
    {
        try
        {

            string connstr = ConfigurationManager.ConnectionStrings["Project_Inventrix_string"].ConnectionString;
            using (SqlConnection con = new SqlConnection(connstr))
            {
                using (SqlCommand cmd = new SqlCommand("pf_crud", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add("@pf_id", SqlDbType.BigInt).Value = edit_pf_id;
                    cmd.Parameters.Add("@pf_name", SqlDbType.VarChar).Value = null;
                    cmd.Parameters.Add("@pf_dol", SqlDbType.Date).Value = null;
                    cmd.Parameters.Add("@pf_isactive", SqlDbType.Bit).Value = null;
                    cmd.Parameters.Add("@pf_app", SqlDbType.VarChar).Value = null;
                    cmd.Parameters.Add("@pf_opr_flag", SqlDbType.VarChar).Value = "read_one";
                    con.Open();
                    //cmd.ExecuteNonQuery();
                    using (SqlDataAdapter pf_sda = new SqlDataAdapter(cmd))
                    {
                        using (DataTable dt = new DataTable())
                        {
                            pf_sda.Fill(dt);
                            DataSet ds = new DataSet();
                            ds.Tables.Add(dt);
                            string pf_op = JsonConvert.SerializeObject(ds);
                            context.Response.Write(pf_op);
                            context.Response.End();
                        }
                    }
                }
            }
        }
        catch (Exception e)
        {

        }
    }


    public void getdata(HttpContext context)
    {
        string connstr = ConfigurationManager.ConnectionStrings["Project_Inventrix_string"].ConnectionString;
        using (SqlConnection con = new SqlConnection(connstr))
        {
            //SqlDataReader dataReader;
            using (SqlCommand cmd = new SqlCommand("Select * from dbo.product_family", con))
            {
                cmd.CommandType = CommandType.Text;
                using (SqlDataAdapter pf_sda = new SqlDataAdapter(cmd))
                {
                    using (DataTable dt = new DataTable())
                    {
                        pf_sda.Fill(dt);
                        DataSet ds = new DataSet();
                        ds.Tables.Add(dt);
                        string pf_op = JsonConvert.SerializeObject(ds);
                        context.Response.Write(pf_op);
                        context.Response.End();

                    }
                }
            }
        }
    }

    public void update_click(HttpContext context, int edit_pf_id)
    {
        string add_pf_name = Convert.ToString(context.Request["family_name"]);
        string add_pf_dol = Convert.ToString(context.Request["pf_dol"]);
        //bool add_pf_isactive = Convert.ToBoolean(context.Request["pf_isactive"]);

        bool add_pf_isactive = true;
        if (Convert.ToString(context.Request["pf_isactive"]) == "pf_active")
            add_pf_isactive = true;
        else if (Convert.ToString(context.Request["pf_isactive"]) == "pf_inactive")
            add_pf_isactive = false;

        string add_pf_app = Convert.ToString(context.Request["pf_app"]);

        // Taking out out connectionstring in a variable from web config
        try
        {

            string connstr = ConfigurationManager.ConnectionStrings["Project_Inventrix_string"].ConnectionString;
            using (SqlConnection con = new SqlConnection(connstr))
            {
                using (SqlCommand cmd = new SqlCommand("pf_crud", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add("@pf_id", SqlDbType.BigInt).Value = edit_pf_id;
                    cmd.Parameters.Add("@pf_name", SqlDbType.VarChar).Value = add_pf_name;
                    cmd.Parameters.Add("@pf_dol", SqlDbType.Date).Value = add_pf_dol;
                    cmd.Parameters.Add("@pf_isactive", SqlDbType.Bit).Value = add_pf_isactive;
                    cmd.Parameters.Add("@pf_app", SqlDbType.VarChar).Value = add_pf_app;
                    cmd.Parameters.Add("@pf_opr_flag", SqlDbType.VarChar).Value = "update";
                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }
        }
        catch (Exception e)
        {

        }
    }

    public void delete_click(HttpContext context, int edit_pf_id)
    {
            try
        {

            string connstr = ConfigurationManager.ConnectionStrings["Project_Inventrix_string"].ConnectionString;
            using (SqlConnection con = new SqlConnection(connstr))
            {
                using (SqlCommand cmd = new SqlCommand("pf_crud", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add("@pf_id", SqlDbType.BigInt).Value = edit_pf_id;
                    cmd.Parameters.Add("@pf_opr_flag", SqlDbType.VarChar).Value = "delete";
                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }
        }
        catch (Exception e)
        {

        }
    }
}