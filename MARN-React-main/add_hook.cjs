const fs = require('fs');

let content = fs.readFileSync('src/hooks/usePropertyFeedback.ts', 'utf8');
content += `
export const useDeletePropertyFeedback = () => {
  const queryClient = useQueryClient()
  return useMutation({
    mutationFn: async ({ propertyId, commentId }: { propertyId: string; commentId?: string }) => {
      let ratingError = null;
      try {
        await propertyFeedbackService.deleteRating(propertyId)
      } catch (e: any) {
        if (e?.response?.status !== 404) ratingError = e;
      }
      
      let commentError = null;
      if (commentId) {
        try {
          await propertyFeedbackService.deleteComment(propertyId, commentId)
        } catch (e: any) {
          if (e?.response?.status !== 404) commentError = e;
        }
      }
      
      if (ratingError && commentError) throw commentError;
      if (ratingError && !commentId) throw ratingError;
      if (commentError && !ratingError) throw commentError;
      
      return true
    },
    onSuccess: (_, variables) => {
      queryClient.invalidateQueries({ queryKey: ['propertyComments', variables.propertyId] })
      queryClient.invalidateQueries({ queryKey: ['propertyRatingSummary', variables.propertyId] })
    },
  })
}
`;
fs.writeFileSync('src/hooks/usePropertyFeedback.ts', content);
