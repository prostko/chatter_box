import { ref } from 'vue';
import api from '@/src/global/services/api';

export function useViewCount() {
  const viewCounts = ref({});

  const getViewCount = async (postId) => {
    const response = await api.get(`/api/v1/posts/${postId}/views`);
    viewCounts.value[postId] = response.data.view_count;
  };

  return {
    viewCounts,
    getViewCount
  };
}