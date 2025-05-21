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
  Select,
  HStack,
  useToast,
} from '@chakra-ui/react';
import DashboardLayout from '../../components/layout/DashboardLayout';
import { useQuery } from '@tanstack/react-query';

interface Report {
  id: number;
  academy_id: number;
  student_id: number;
  report_type: string;
  report_data: any;
  generated_by: number;
  created_at: string;
}

interface Academy {
  id: number;
  name: string;
}

interface Student {
  id: number;
  name: string;
}

export default function ReportsPage() {
  const toast = useToast();
  const [selectedAcademy, setSelectedAcademy] = React.useState<string>('');
  const [selectedStudent, setSelectedStudent] = React.useState<string>('');

  const { data: academies } = useQuery<Academy[]>({
    queryKey: ['academies'],
    queryFn: async () => {
      const response = await fetch('http://localhost:3001/api/academies');
      if (!response.ok) {
        throw new Error('Failed to fetch academies');
      }
      return response.json();
    },
  });

  const { data: students } = useQuery<Student[]>({
    queryKey: ['students', selectedAcademy],
    queryFn: async () => {
      if (!selectedAcademy) return [];
      const response = await fetch(`http://localhost:3001/api/academies/${selectedAcademy}/students`);
      if (!response.ok) {
        throw new Error('Failed to fetch students');
      }
      return response.json();
    },
    enabled: !!selectedAcademy,
  });

  const { data: reports } = useQuery<Report[]>({
    queryKey: ['reports', selectedAcademy, selectedStudent],
    queryFn: async () => {
      let url = 'http://localhost:3001/api/reports';
      if (selectedAcademy) {
        url += `?academy_id=${selectedAcademy}`;
      }
      if (selectedStudent) {
        url += `&student_id=${selectedStudent}`;
      }
      const response = await fetch(url);
      if (!response.ok) {
        throw new Error('Failed to fetch reports');
      }
      return response.json();
    },
  });

  const handleGenerateReport = async () => {
    try {
      const response = await fetch('http://localhost:3001/api/reports/generate', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          academy_id: selectedAcademy,
          student_id: selectedStudent,
          report_type: 'progress',
        }),
      });

      if (!response.ok) {
        throw new Error('Failed to generate report');
      }

      toast({
        title: '리포트가 생성되었습니다.',
        status: 'success',
        duration: 3000,
        isClosable: true,
      });
    } catch (error) {
      toast({
        title: '리포트 생성에 실패했습니다.',
        status: 'error',
        duration: 3000,
        isClosable: true,
      });
    }
  };

  return (
    <DashboardLayout>
      <Container maxW="container.xl" py={5}>
        <Heading mb={8}>리포트</Heading>

        <Box mb={8}>
          <HStack spacing={4}>
            <Select
              placeholder="학원 선택"
              value={selectedAcademy}
              onChange={(e) => setSelectedAcademy(e.target.value)}
            >
              {academies?.map((academy) => (
                <option key={academy.id} value={academy.id}>
                  {academy.name}
                </option>
              ))}
            </Select>

            <Select
              placeholder="학생 선택"
              value={selectedStudent}
              onChange={(e) => setSelectedStudent(e.target.value)}
              isDisabled={!selectedAcademy}
            >
              {students?.map((student) => (
                <option key={student.id} value={student.id}>
                  {student.name}
                </option>
              ))}
            </Select>

            <Button
              colorScheme="brand"
              onClick={handleGenerateReport}
              isDisabled={!selectedAcademy || !selectedStudent}
            >
              리포트 생성
            </Button>
          </HStack>
        </Box>

        <Table variant="simple">
          <Thead>
            <Tr>
              <Th>ID</Th>
              <Th>학원</Th>
              <Th>학생</Th>
              <Th>리포트 유형</Th>
              <Th>생성일</Th>
              <Th>작업</Th>
            </Tr>
          </Thead>
          <Tbody>
            {reports?.map((report) => (
              <Tr key={report.id}>
                <Td>{report.id}</Td>
                <Td>
                  {academies?.find((a) => a.id === report.academy_id)?.name}
                </Td>
                <Td>
                  {students?.find((s) => s.id === report.student_id)?.name}
                </Td>
                <Td>{report.report_type}</Td>
                <Td>{new Date(report.created_at).toLocaleDateString()}</Td>
                <Td>
                  <Button
                    size="sm"
                    colorScheme="brand"
                    onClick={() => window.open(`/api/reports/${report.id}/download`, '_blank')}
                  >
                    다운로드
                  </Button>
                </Td>
              </Tr>
            ))}
          </Tbody>
        </Table>
      </Container>
    </DashboardLayout>
  );
} 