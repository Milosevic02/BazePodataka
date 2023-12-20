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
    public class SceneDAOImpl:ISceneDAO
    {
        public List<Scene>FindSceneByTheatre(int theatreId)
        {
            string query = "select id_sc, name_sc, numofseats_sc, theatre_id_th " +
                "from scene where theatre_id_th = :theatre_id_th";

            List<Scene> sceneList = new List<Scene>();
            using(IDbConnection connection = ConnectionUtil_Pooling.GetConnection())
            {
                connection.Open();
                using(IDbCommand command = connection.CreateCommand())
                {
                    command.CommandText = query;
                    ParameterUtil.AddParameter(command, "theatre_id_th",DbType.Int32);
                    command.Prepare();
                    ParameterUtil.SetParameterValue(command, "theatre_id_th", theatreId);
                    using(IDataReader reader = command.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            Scene scene = new Scene(reader.GetInt32(0), reader.GetString(1), reader.GetInt32(2), reader.GetInt32(3));
                            sceneList.Add(scene);
                        }
                    }
                }
            }
            return sceneList;
        }
    }
}
