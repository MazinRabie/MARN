import { Upload, X, FileText } from 'lucide-react'
import { Button } from '../../../components/ui/button'
import { PropertyFormData, FileData, TouchedFields } from '../types'
import { useRef } from 'react'
import { useTranslation } from 'react-i18next'
import { getImageUrl } from '@/constants/assets'

interface LegalDocsStepProps {
  formData: PropertyFormData
  updateFormData: (updates: Partial<PropertyFormData>) => void
  touched?: TouchedFields
}

export function LegalDocsStep({ formData, updateFormData, touched }: LegalDocsStepProps) {
  const { t } = useTranslation('properties')
  const fileInputRef = useRef<HTMLInputElement>(null)

  const handleFileChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    if (!e.target.files?.length) return

    const files = Array.from(e.target.files)
    const newDocs: FileData[] = []
    
    let processed = 0
    files.forEach(file => {
      const reader = new FileReader()
      reader.onload = (event) => {
        if (event.target?.result) {
          newDocs.push({
            name: file.name,
            type: file.type,
            size: file.size,
            dataUrl: event.target.result as string,
            file
          })
        }
        processed++
        if (processed === files.length) {
          updateFormData({ legalDocs: [...(formData.legalDocs || []), ...newDocs] })
        }
      }
      reader.readAsDataURL(file)
    })
  }

  const removeDoc = (index: number) => {
    const updated = [...(formData.legalDocs || [])]
    updated.splice(index, 1)
    updateFormData({ legalDocs: updated })
  }

  const docsList = formData.legalDocs || []
  const isError = touched?.legalDocs && docsList.length === 0
  const uploadBoxClass = `border-2 border-dashed ${isError ? 'border-red-500 bg-red-50' : 'border-[#3A6EA5]/30'} rounded-2xl p-12 text-center hover:border-[#3A6EA5] transition-colors cursor-pointer`

  return (
    <div className="space-y-6">
      <h2 className="text-2xl font-semibold text-[#1a1a1a] mb-6">
        {t('editProperty.legalDocsStep.title')} <span className="text-red-500">*</span>
      </h2>

      <div className="bg-white rounded-2xl p-8">
        <input 
          type="file" 
          multiple 
          accept=".pdf,.doc,.docx" 
          className="hidden" 
          ref={fileInputRef}
          onChange={handleFileChange}
        />
        <div 
          onClick={() => fileInputRef.current?.click()}
          className={uploadBoxClass}
        >
          <Upload className="w-16 h-16 mx-auto mb-4 text-[#3A6EA5]" />
          <h3 className="text-lg font-semibold text-[#1a1a1a] mb-2">
            {t('editProperty.legalDocsStep.dragDropDocs')}
          </h3>
          <p className="text-[#4a5565] mb-4">
            {t('editProperty.legalDocsStep.orClickToBrowse')}
          </p>
          <Button 
            type="button" 
            className="bg-[#3A6EA5] hover:bg-[#2a5a8a] text-white rounded-xl"
            onClick={(e) => {
              e.stopPropagation()
              fileInputRef.current?.click()
            }}
          >
            {t('editProperty.legalDocsStep.chooseFiles')}
          </Button>
        </div>
      </div>

      {formData.existingProofOfOwnershipUrl && (
        <div className="bg-white rounded-2xl p-6 mb-6 border border-[#3A6EA5]/20">
          <h3 className="text-lg font-semibold text-[#1a1a1a] mb-4">{t('editProperty.legalDocsStep.currentProofOfOwnership')}</h3>
          <div className="flex items-center gap-3 p-4 rounded-xl bg-[#E5EBF0]">
            <div className="bg-[#9CBBDC]/20 p-2 rounded-lg text-[#3A6EA5]">
              <FileText className="w-6 h-6" />
            </div>
            <div>
              <a 
                href={getImageUrl(formData.existingProofOfOwnershipUrl)} 
                target="_blank" 
                rel="noreferrer"
                className="text-sm font-medium text-[#3A6EA5] hover:underline"
              >
                {t('editProperty.legalDocsStep.viewExistingDocument')}
              </a>
            </div>
          </div>
          <p className="text-sm text-[#4a5565] mt-3">{t('editProperty.legalDocsStep.uploadingNewDocumentReplacesExisting')}</p>
        </div>
      )}

      {docsList.length > 0 && (
        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
          {docsList.map((doc, index) => (
            <div
              key={index}
              className="flex items-center justify-between p-4 rounded-xl bg-white border border-[#3A6EA5]/20 shadow-sm"
            >
              <div className="flex items-center gap-3 overflow-hidden">
                <div className="bg-[#9CBBDC]/20 p-2 rounded-lg text-[#3A6EA5]">
                  <FileText className="w-6 h-6" />
                </div>
                <div className="truncate">
                  <p className="text-sm font-medium text-[#1a1a1a] truncate" title={doc.name}>{doc.name}</p>
                  <p className="text-xs text-[#4a5565]">{(doc.size / 1024 / 1024).toFixed(2)} MB</p>
                </div>
              </div>
              <button
                type="button"
                onClick={() => removeDoc(index)}
                className="text-red-500 hover:bg-red-50 p-2 rounded-lg transition-colors"
              >
                <X className="w-5 h-5" />
              </button>
            </div>
          ))}
        </div>
      )}

      <div className="bg-[#9CBBDC]/20 rounded-2xl p-4">
        <p className="text-sm text-[#1a1a1a]">
          {t('editProperty.legalDocsStep.tip')}
        </p>
      </div>
    </div>
  )
}
