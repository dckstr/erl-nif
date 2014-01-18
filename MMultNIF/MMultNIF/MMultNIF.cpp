// MMultNIF.cpp : Defines the exported functions for the DLL application.
//

#include "mmultnif.h"

extern "C"
{

	__declspec(dllexport) ERL_NIF_TERM native_mmult(ErlNifEnv* env, int argc, const ERL_NIF_TERM* argv);


	//Multiply NxM matrix by MxK matrix
	ERL_NIF_TERM native_mmult(ErlNifEnv* env, int argc, const ERL_NIF_TERM* argv)
	{
		int n,m,k;

		//DebugBreak();

		const ERL_NIF_TERM *mat1, *mat2;
		const ERL_NIF_TERM *row;

		enif_get_tuple(env,argv[0],&n,&mat1);
		enif_get_tuple(env,argv[1],&m,&mat2);
		enif_get_tuple(env,mat2[0],&k,&row);

		//Improve locality
		ERL_NIF_TERM *outrow = (ERL_NIF_TERM*) malloc(sizeof(ERL_NIF_TERM) * max(max(n,k),m));
		double *in_mat1 = (double*) malloc(sizeof(double) * n * m);
		double *cim1 = in_mat1;
		double *in_mat2 = (double*) malloc(sizeof(double) * m * k);
		double *cim2 = in_mat2;
		ERL_NIF_TERM *out_write = outrow;

		ERL_NIF_TERM *outmat = (ERL_NIF_TERM*) malloc(sizeof(ERL_NIF_TERM) * max(max(n,k),m));

		for (int i = 0; i < n; i++)
		{
			enif_get_tuple(env,mat1[i],&m,&row);
			for (int j = 0; j < m; j++, cim1++)
				enif_get_double(env,row[j],cim1);
		}

		for (int i = 0; i < m; i++)
		{
			enif_get_tuple(env,mat2[i],&k,&row);
			for (int j = 0; j < k; j++, cim2++)
				enif_get_double(env,row[j],cim2);
		}

		//Matrices have been loaded

		for (int i = 0; i < n; i++)
		{
			out_write = outrow;

			for (int j = 0; j < k; j++, out_write++)
			{
				double sum = 0;
				for (int z = 0; z < m; z++)
					sum += in_mat1[i * m + z] * in_mat2[j + z * k];

				*out_write = enif_make_double(env,sum);
			}

			outmat[i] = enif_make_tuple_from_array(env,outrow,k);
		}

		ERL_NIF_TERM grand_total = enif_make_tuple_from_array(env,outmat,n);

		free(in_mat1);
		free(in_mat2);
		free(outmat);
		free(outrow);

		return grand_total;
	}

	
	static ErlNifFunc nif_funcs[] =
	{
	    {"native_mmult", 2, native_mmult}
	};

	ERL_NIF_INIT(mmultnif,nif_funcs,NULL,NULL,NULL,NULL)
};