using ODP_NET_Theatre.ConnectionPool;
using ODP_NET_Theatre.Model;
using ODP_NET_Theatre.Utils;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ODP_NET_Theatre.DAO.Impl
{
    public class RoleDAOImpl:IRoleDAO
    {
        public List<Role> FindRoleByPlayID(int plId)
        {
            string query = "select id_ro, name_ro, gender_ro, type_ro, play_id_pl " +
                "from role " +
                "where play_id_pl = :play_id_pl";
            List<Role> result = new List<Role>(); 

            using(IDbConnection connection = ConnectionUtil_Pooling.GetConnection())
            {
                connection.Open();
                using(IDbCommand command = connection.CreateCommand())
                {
                    command.CommandText = query;
                    ParameterUtil.AddParameter(command, "play_id_pl", DbType.Int32);
                    command.Prepare();
                    ParameterUtil.SetParameterValue(command, "play_id_pl",plId);
                    using(IDataReader reader = command.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            Role u = new Role(reader.GetInt32(0), reader.GetString(1), reader.GetString(2), reader.GetString(3), reader.GetInt32(4));
                            result.Add(u);

                        }
                    }
                }
            }
            return result;
        }

        public int FindCountForRoleGender(int idPl, string gender)
        {
            string query = "select count(gender_ro) " +
                "from role " +
                "where play_id_pl=:play_id_pl and gender_ro=:gender_ro";

            using (IDbConnection connection = ConnectionUtil_Pooling.GetConnection())
            {
                connection.Open();
                using (IDbCommand command = connection.CreateCommand())
                {
                    command.CommandText = query;
                    ParameterUtil.AddParameter(command, "play_id_pl", DbType.Int32);
                    ParameterUtil.AddParameter(command, "gender_ro", DbType.StringFixedLength, 1);
                    command.Prepare();

                    ParameterUtil.SetParameterValue(command, "play_id_pl", idPl);
                    ParameterUtil.SetParameterValue(command, "gender_ro", gender);

                    object result = command.ExecuteScalar();
                    if (result == null) return -1;
                    return Convert.ToInt32(result);
                }
            }
        }
    }


}
