import React from 'react';
import {
  Box,
  Button,
  Container,
  Heading,
  Table,
  Thead,
  Tbody,
  Tr,
  Th,
  Td,
  Badge,
  useDisclosure,
  Modal,
  ModalOverlay,
  ModalContent,
  ModalHeader,
  ModalBody,
  ModalCloseButton,
  FormControl,
  FormLabel,
  Input,
  Select,
  Textarea,
  VStack,
  useToast,
} from '@chakra-ui/react';
import DashboardLayout from '../../components/layout/DashboardLayout';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';

interface LearningContent {
  id: number;
  title: string;
  description: string;
  content_type: string;
  difficulty_level: string;
  content_url: string;
  is_active: boolean;
  created_at: string;
}

export default function ContentsPage() {
  const { isOpen, onOpen, onClose } = useDisclosure();
  const toast = useToast();
  const queryClient = useQueryClient();

  const { data: contents, isLoading } = useQuery<LearningContent[]>({
    queryKey: ['contents'],
    queryFn: async () => {
      const response = await fetch('http://localhost:3001/api/contents');
      if (!response.ok) {
        throw new Error('Failed to fetch contents');
      }
      return response.json();
    },
  });

  const createContent = useMutation({
    mutationFn: async (newContent: Omit<LearningContent, 'id' | 'created_at'>) => {
      const response = await fetch('http://localhost:3001/api/contents', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(newContent),
      });
      if (!response.ok) {
        throw new Error('Failed to create content');
      }
      return response.json();
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['contents'] });
      toast({
        title: '콘텐츠가 등록되었습니다.',
        status: 'success',
        duration: 3000,
        isClosable: true,
      });
      onClose();
    },
  });

  const handleSubmit = (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();
    const formData = new FormData(e.currentTarget);
    createContent.mutate({
      title: formData.get('title') as string,
      description: formData.get('description') as string,
      content_type: formData.get('content_type') as string,
      difficulty_level: formData.get('difficulty_level') as string,
      content_url: formData.get('content_url') as string,
      is_active: true,
    });
  };

  return (
    <DashboardLayout>
      <Container maxW="container.xl" py={5}>
        <Box display="flex" justifyContent="space-between" alignItems="center" mb={8}>
          <Heading>콘텐츠 관리</Heading>
          <Button colorScheme="brand" onClick={onOpen}>
            콘텐츠 추가
          </Button>
        </Box>

        <Table variant="simple">
          <Thead>
            <Tr>
              <Th>ID</Th>
              <Th>제목</Th>
              <Th>설명</Th>
              <Th>유형</Th>
              <Th>난이도</Th>
              <Th>상태</Th>
              <Th>등록일</Th>
            </Tr>
          </Thead>
          <Tbody>
            {contents?.map((content) => (
              <Tr key={content.id}>
                <Td>{content.id}</Td>
                <Td>{content.title}</Td>
                <Td>{content.description}</Td>
                <Td>{content.content_type}</Td>
                <Td>{content.difficulty_level}</Td>
                <Td>
                  <Badge colorScheme={content.is_active ? 'green' : 'red'}>
                    {content.is_active ? '활성' : '비활성'}
                  </Badge>
                </Td>
                <Td>{new Date(content.created_at).toLocaleDateString()}</Td>
              </Tr>
            ))}
          </Tbody>
        </Table>

        <Modal isOpen={isOpen} onClose={onClose}>
          <ModalOverlay />
          <ModalContent>
            <ModalHeader>콘텐츠 추가</ModalHeader>
            <ModalCloseButton />
            <ModalBody>
              <form onSubmit={handleSubmit}>
                <VStack spacing={4}>
                  <FormControl isRequired>
                    <FormLabel>제목</FormLabel>
                    <Input name="title" />
                  </FormControl>
                  <FormControl isRequired>
                    <FormLabel>설명</FormLabel>
                    <Textarea name="description" />
                  </FormControl>
                  <FormControl isRequired>
                    <FormLabel>유형</FormLabel>
                    <Select name="content_type">
                      <option value="video">비디오</option>
                      <option value="quiz">퀴즈</option>
                      <option value="reading">읽기</option>
                      <option value="listening">듣기</option>
                    </Select>
                  </FormControl>
                  <FormControl isRequired>
                    <FormLabel>난이도</FormLabel>
                    <Select name="difficulty_level">
                      <option value="beginner">초급</option>
                      <option value="intermediate">중급</option>
                      <option value="advanced">고급</option>
                    </Select>
                  </FormControl>
                  <FormControl isRequired>
                    <FormLabel>콘텐츠 URL</FormLabel>
                    <Input name="content_url" />
                  </FormControl>
                  <Button type="submit" colorScheme="brand" width="full" mb={4}>
                    등록
                  </Button>
                </VStack>
              </form>
            </ModalBody>
          </ModalContent>
        </Modal>
      </Container>
    </DashboardLayout>
  );
} 