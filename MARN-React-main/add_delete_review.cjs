const fs = require('fs');

let content = fs.readFileSync('src/app/pages/PropertyDetailsPage.tsx', 'utf8');

// 1. Add imports
content = content.replace(
  `import { usePropertyRatingSummary, usePropertyComments, useAddPropertyFeedback, useUpdatePropertyComment } from '@/hooks/usePropertyFeedback'`,
  `import { usePropertyRatingSummary, usePropertyComments, useAddPropertyFeedback, useUpdatePropertyComment, useDeletePropertyFeedback } from '@/hooks/usePropertyFeedback'\nimport { Trash2 } from 'lucide-react'`
);

// 2. Add useDeletePropertyFeedback, state and functions
content = content.replace(
  `  const updateComment = useUpdatePropertyComment()`,
  `  const updateComment = useUpdatePropertyComment()\n  const deleteFeedbackMutation = useDeletePropertyFeedback()\n  const [isDeleteConfirmOpen, setIsDeleteConfirmOpen] = useState(false)\n  const [commentToDelete, setCommentToDelete] = useState<number | null>(null)\n\n  const handleDeleteComment = () => {\n    if (commentToDelete === null) return\n    deleteFeedbackMutation.mutate(\n      { propertyId: id!, commentId: commentToDelete.toString() },\n      {\n        onSuccess: () => {\n          setIsDeleteConfirmOpen(false)\n          setCommentToDelete(null)\n          toast.success(t('details.reviews.deleteSuccess', { ns: 'properties' }) || 'Review deleted successfully.')\n        },\n        onError: () => toast.error(t('details.reviews.deleteError', { ns: 'properties' }) || 'Failed to delete review')\n      }\n    )\n  }`
);

// 3. Sort comments array
content = content.replace(
  `  const comments = commentsData?.data?.items || []`,
  `  const comments = useMemo(() => {\n    const items = commentsData?.data?.items || []\n    if (!user) return items\n    return [...items].sort((a, b) => {\n      if (a.userId === user.id && b.userId !== user.id) return -1\n      if (a.userId !== user.id && b.userId === user.id) return 1\n      return 0\n    })\n  }, [commentsData?.data?.items, user])`
);

// 4. Comment rendering logic & Dropdown Menu
content = content.replace(
  `<h4 className="font-semibold text-[#1a1a1a]">\n                              {comment.userDisplayName || 'Guest'}\n                            </h4>`,
  `<h4 className="font-semibold text-[#1a1a1a] flex items-center gap-2">\n                              {comment.userDisplayName || 'Guest'}\n                              {comment.userId === user?.id && (\n                                <span className="px-2 py-0.5 bg-[#9CBBDC]/20 text-[#3A6EA5] rounded-full text-xs font-medium">\n                                  {t('details.reviews.yourComment', { ns: 'properties' }) || 'Your comment'}\n                                </span>\n                              )}\n                            </h4>`
);

content = content.replace(
  `                                    <DropdownMenuItem\n                                      className="text-red-600 focus:text-red-600 focus:bg-red-50 cursor-pointer"\n                                      onClick={() => {\n                                        setSelectedReviewToReport(comment)\n                                        setIsReviewReportModalOpen(true)\n                                      }}\n                                    >\n                                      <ShieldAlert className="w-4 h-4 mr-2" />\n                                      Report Review\n                                    </DropdownMenuItem>`,
  `                                    {comment.userId === user?.id ? (\n                                      <DropdownMenuItem\n                                        className="text-red-600 focus:text-red-600 focus:bg-red-50 cursor-pointer"\n                                        onClick={() => {\n                                          setCommentToDelete(comment.commentId)\n                                          setIsDeleteConfirmOpen(true)\n                                        }}\n                                      >\n                                        <Trash2 className="w-4 h-4 mr-2" />\n                                        {t('details.reviews.deleteReview', { ns: 'properties' }) || 'Delete'}\n                                      </DropdownMenuItem>\n                                    ) : (\n                                      <DropdownMenuItem\n                                        className="text-red-600 focus:text-red-600 focus:bg-red-50 cursor-pointer"\n                                        onClick={() => {\n                                          setSelectedReviewToReport(comment)\n                                          setIsReviewReportModalOpen(true)\n                                        }}\n                                      >\n                                        <ShieldAlert className="w-4 h-4 mr-2" />\n                                        Report Review\n                                      </DropdownMenuItem>\n                                    )}`
);

// 5. Delete Confirmation Dialog
content = content.replace(
  `      <Dialog open={isReviewReportModalOpen} onOpenChange={(open) => {`,
  `      <Dialog open={isDeleteConfirmOpen} onOpenChange={setIsDeleteConfirmOpen}>\n        <DialogContent className="sm:max-w-[425px] rounded-2xl" dir="auto">\n          <DialogHeader>\n            <DialogTitle>{t('details.reviews.deleteReview', { ns: 'properties' }) || 'Delete Review'}</DialogTitle>\n          </DialogHeader>\n          <div className="py-4">\n            <p className="text-sm text-[#4a5565] mb-4">\n              {t('details.reviews.deleteReviewConfirm', { ns: 'properties' }) || 'Are you sure you want to delete your review?'}\n            </p>\n            <div className="flex justify-end gap-3">\n              <Button\n                variant="outline"\n                onClick={() => setIsDeleteConfirmOpen(false)}\n                className="rounded-xl border-[#e2e8f0] text-[#4a5565] hover:bg-[#f8fafc]"\n                disabled={deleteFeedbackMutation.isPending}\n              >\n                {t('cancel', { ns: 'common' }) || 'Cancel'}\n              </Button>\n              <Button\n                onClick={handleDeleteComment}\n                className="rounded-xl bg-red-600 hover:bg-red-700 text-white"\n                disabled={deleteFeedbackMutation.isPending}\n              >\n                {deleteFeedbackMutation.isPending ? (t('details.reviews.deleting', { ns: 'properties' }) || 'Deleting...') : (t('details.reviews.deleteReview', { ns: 'properties' }) || 'Delete')}\n              </Button>\n            </div>\n          </div>\n        </DialogContent>\n      </Dialog>\n\n      <Dialog open={isReviewReportModalOpen} onOpenChange={(open) => {`
);

fs.writeFileSync('src/app/pages/PropertyDetailsPage.tsx', content);
