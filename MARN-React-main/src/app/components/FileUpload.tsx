import { useState, useRef } from 'react'
import { Upload, X, FileText, CheckCircle } from 'lucide-react'
import { Button } from './ui/button'

interface FileUploadProps {
  label: string
  required?: boolean
  onFileChange?: (file: File | null) => void
  accept?: string
  maxSize?: number // in MB
}

export function FileUpload({
  label,
  required = false,
  onFileChange,
  accept = '*',
  maxSize = 10,
}: FileUploadProps) {
  const [file, setFile] = useState<File | null>(null)
  const [isDragging, setIsDragging] = useState(false)
  const [error, setError] = useState<string>('')
  const fileInputRef = useRef<HTMLInputElement>(null)

  const handleDragOver = (e: React.DragEvent) => {
    e.preventDefault()
    setIsDragging(true)
  }

  const handleDragLeave = () => {
    setIsDragging(false)
  }

  const validateFile = (file: File): boolean => {
    if (maxSize && file.size > maxSize * 1024 * 1024) {
      setError(`File size must be less than ${maxSize}MB`)
      return false
    }
    return true
  }

  const handleDrop = (e: React.DragEvent) => {
    e.preventDefault()
    setIsDragging(false)
    setError('')

    const droppedFile = e.dataTransfer.files[0]
    if (droppedFile && validateFile(droppedFile)) {
      setFile(droppedFile)
      onFileChange?.(droppedFile)
    }
  }

  const handleFileSelect = (e: React.ChangeEvent<HTMLInputElement>) => {
    setError('')
    const selectedFile = e.target.files?.[0]
    if (selectedFile && validateFile(selectedFile)) {
      setFile(selectedFile)
      onFileChange?.(selectedFile)
    }
  }

  const handleRemove = () => {
    setFile(null)
    setError('')
    onFileChange?.(null)
    if (fileInputRef.current) {
      fileInputRef.current.value = ''
    }
  }

  const handleBrowseClick = () => {
    fileInputRef.current?.click()
  }

  return (
    <div className="space-y-2">
      <div className="flex items-center justify-between">
        <label className="text-[#1a1a1a] font-medium">
          {label}
          {required && <span className="text-red-500 ml-1">*</span>}
        </label>
        {file && (
          <span className="text-sm text-green-600 flex items-center gap-1">
            <CheckCircle className="w-4 h-4" />
            Uploaded
          </span>
        )}
      </div>

      {!file ? (
        <div
          onDragOver={handleDragOver}
          onDragLeave={handleDragLeave}
          onDrop={handleDrop}
          className={`relative border-2 border-dashed rounded-2xl p-8 text-center transition-all cursor-pointer ${
            isDragging
              ? 'border-[#3A6EA5] bg-[#3A6EA5]/10'
              : 'border-[#3A6EA5]/30 bg-[#9CBBDC]/20 hover:border-[#3A6EA5] hover:bg-[#3A6EA5]/5'
          }`}
          onClick={handleBrowseClick}
        >
          <Upload
            className={`w-12 h-12 mx-auto mb-4 ${isDragging ? 'text-[#3A6EA5]' : 'text-[#4a5565]'}`}
          />
          <p className="text-[#1a1a1a] font-medium mb-2">
            {isDragging ? 'Drop file here' : 'Drag & drop your file here'}
          </p>
          <p className="text-sm text-[#4a5565] mb-4">or</p>
          <Button
            type="button"
            variant="outline"
            className="border-[#3A6EA5] text-[#3A6EA5] hover:bg-[#3A6EA5] hover:text-white rounded-xl"
            onClick={(e) => {
              e.stopPropagation()
              handleBrowseClick()
            }}
          >
            Browse Files
          </Button>
          <p className="text-xs text-[#4a5565] mt-4">
            Maximum file size: {maxSize}MB
          </p>
          <input
            ref={fileInputRef}
            type="file"
            accept={accept}
            onChange={handleFileSelect}
            className="hidden"
          />
        </div>
      ) : (
        <div className="bg-white rounded-2xl p-6 border-2 border-[#3A6EA5]/20">
          <div className="flex items-center justify-between">
            <div className="flex items-center gap-4">
              <div className="w-12 h-12 rounded-xl bg-[#9CBBDC]/30 flex items-center justify-center">
                <FileText className="w-6 h-6 text-[#3A6EA5]" />
              </div>
              <div>
                <p className="text-[#1a1a1a] font-medium truncate max-w-[300px]">
                  {file.name}
                </p>
                <p className="text-sm text-[#4a5565]">
                  {(file.size / 1024 / 1024).toFixed(2)} MB
                </p>
              </div>
            </div>
            <div className="flex items-center gap-2">
              <Button
                type="button"
                variant="outline"
                size="sm"
                className="rounded-xl border-[#3A6EA5]/20"
                onClick={handleBrowseClick}
              >
                Replace
              </Button>
              <Button
                type="button"
                variant="ghost"
                size="sm"
                className="text-red-500 hover:bg-red-50 rounded-xl"
                onClick={handleRemove}
              >
                <X className="w-4 h-4" />
              </Button>
            </div>
          </div>
        </div>
      )}

      {error && (
        <p className="text-sm text-red-500 flex items-center gap-1">{error}</p>
      )}
    </div>
  )
}
