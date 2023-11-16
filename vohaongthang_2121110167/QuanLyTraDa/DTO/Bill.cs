using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace QuanLyTraDa.DTO
{
    internal class Bill
    {
        public Bill(int id, DateTime? DataCheckIn, DateTime? dateCheckOut, int status,int discount) 
        {
            this.ID = id;
            this.DateCheckIn = dateCheckIn;
            this.DateCheckOut = dateCheckOut;
            this.Status = status;
            this.Discount = discount;
        }

        public Bill(DataRow row)
        {
            this.ID = (int)row["id"];
            this.DateCheckIn = (DateTime?)row["dateCheckIn"];

            var dataCheckOutTemp = row["dateCheckOut"];
            if (dataCheckOutTemp.ToString() != "")
                this.DateCheckOut = (DateTime?)dataCheckOutTemp;
            
            this.Status = (int)row["status"];
            if (row["discount"].ToString() != "")
                this.Discount = (int)row["discount"];
        }

        private int discount;
        private int status;
        public int Status
        {
            get { return status; }
            set { status = value; }
        }


        private DateTime? dateCheckOut;

        public DateTime? DateCheckOut
        {
            get { return dateCheckOut; }
            set { dateCheckOut = value; }
        }

        private DateTime? dateCheckIn;

        public DateTime? DateCheckIn
        {
            get { return dateCheckIn; }
            set { dateCheckIn = value; }
        }


        private int iD;

        public int ID
        {
            get { return iD; }
            set { iD = value; }
        }

        public int Discount { get => discount; set => discount = value; }
    }
}
