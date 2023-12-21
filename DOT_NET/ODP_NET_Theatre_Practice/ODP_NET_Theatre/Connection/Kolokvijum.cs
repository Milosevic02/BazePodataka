using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ODP_NET_Theatre.Connection
{
    public class Kolokvijum
    {
    }

    //1. KONEKCIJA 
    public class ConnectionUtil_Pooling : IDisposable
    {
        private static IDbConnection instance = null;

        public static IDbConnection GetConnection()
        {
            if (instance == null || instance.State == System.Data.ConnectionState.Closed)
            {


            }
            return instance;
        }

        public void Dispose()
        {


        }
    }
}
