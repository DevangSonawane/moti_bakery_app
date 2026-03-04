import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import { toast } from 'sonner';
import api from '@/lib/axios';

export const useCakes = (filters = {}) =>
  useQuery({
    queryKey: ['cakes', filters],
    queryFn: () => api.get('/cakes', { params: filters }).then((response) => response.data),
  });

export const useCreateCake = () => {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: (payload) => api.post('/cakes', payload).then((response) => response.data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['cakes'] });
      toast.success('Cake added successfully');
    },
  });
};

export const useUpdateCake = () => {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: ({ id, payload }) => api.put(`/cakes/${id}`, payload).then((response) => response.data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['cakes'] });
      toast.success('Cake updated successfully');
    },
  });
};

export const useDeleteCake = () => {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: (id) => api.delete(`/cakes/${id}`).then((response) => response.data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['cakes'] });
      toast.success('Cake deleted');
    },
  });
};
