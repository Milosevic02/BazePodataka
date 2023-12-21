using System.Collections.Generic;

namespace ODP_NET_Theatre.DAO
{
	public interface ICRUDDao<T, ID>
    {
        int Count();

        int DeleteById(ID id);

        bool ExistsById(ID id);

        IEnumerable<T> FindAll();

        T FindById(ID id);

        int Save(T entity);

    }
}