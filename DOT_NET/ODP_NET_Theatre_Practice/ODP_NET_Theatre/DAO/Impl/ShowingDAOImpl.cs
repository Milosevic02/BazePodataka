using ODP_NET_Theatre.ConnectionPool;
using ODP_NET_Theatre.DTO.ComplexQuery2;
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
    public class ShowingDAOImpl:IShowingDAO
    {
        public int Count()
        {
            throw new NotImplementedException();
        }

        public int DeleteById(int id)
        {
            throw new NotImplementedException();
        }

        public bool ExistsById(int id)
        {
            throw new NotImplementedException();
        }

        public IEnumerable<Showing> FindAll()
        {
            throw new NotImplementedException();
        }

        public Showing FindById(int id)
        {
            throw new NotImplementedException();

        }

        public int Save(Showing entity)
        {
            throw new NotImplementedException();

        }

        public List<Showing> FindShowingByPlayId(int playId)
        {
            string query = "select ordnum_sh, date_sh, time_sh, numofspec_sh, play_id_pl, scene_id_sc from showing where id_pl = :id_pl";

            List<Showing> showings = new List<Showing>();   

            using(IDbConnection connection = ConnectionUtil_Pooling.GetConnection())
            {
                connection.Open();
                using(IDbCommand command = connection.CreateCommand()) 
                { 
                    
                    command.CommandText = query;
                    ParameterUtil.AddParameter(command, "play_id_pl", DbType.Int32);
                    command.Prepare();
                    ParameterUtil.SetParameterValue(command, "play_id_pl", playId);
                    using(IDataReader reader = command.ExecuteReader())
                    {
                        while(reader.Read())
                        {
                            Showing showing = new Showing(reader.GetInt32(0), reader.GetDateTime(1),
                                reader.GetDateTime(2), reader.GetInt32(3), reader.GetInt32(4), reader.GetInt32(5));
                            showings.Add(showing);
                        }
                    }
                }
                return showings;
            }

        }

        public List<PlayShowingsStatsDTO> FindSumAvgCountForShowingPlay()
        {
            string query = "select play_id_pl , SUM(numofspec_sh) , AVG(numofspec_sh),COUNT(*) from showing group by play_id_pl ";

            List<PlayShowingsStatsDTO>stats = new List<PlayShowingsStatsDTO>();

            using(IDbConnection connection = ConnectionUtil_Pooling.GetConnection())
            {
                connection.Open();
                using(IDbCommand command = connection.CreateCommand())
                {
                    command.CommandText = query;
                    using(IDataReader reader = command.ExecuteReader())
                    {
                        while(reader.Read())
                        {
                            PlayShowingsStatsDTO showing = new PlayShowingsStatsDTO(reader.GetInt32(0), reader.GetInt32(1), reader.GetFloat(2), reader.GetInt32(3));
                            stats.Add(showing);
                        }
                    }
                }
            }
            return stats;
        }


    }
}
